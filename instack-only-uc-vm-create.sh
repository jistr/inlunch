#!/bin/bash

set -euo pipefail


ONLY_UC_DIR=${ONLY_UC_DIR:-"./instack-only-uc"}
INSTACK_PUBLIC_KEY=${INSTACK_PUBLIC_KEY:-"$HOME/.ssh/id_rsa.pub"}
INSTACK_NETWORK=${INSTACK_NETWORK:-"default"}
INSTACK_MAC=${INSTACK_MAC:-"52:54:00:12:57:4c"}
INSTACK_MEMORY=${INSTACK_MEMORY:-"3096"}
INSTACK_VCPUS=${INSTACK_VCPUS:-"1"}

if sudo virsh list --all | grep instack-only-uc; then
    echo "VM instack-only-uc is already defined."
    exit 1
fi

if [ ! -v INSTACK_DIST ]; then
    echo "Please export INSTACK_DIST, there is no default. The available choices are:"
    virt-builder --list | awk '{ print $1 }'
    exit 1
fi

mkdir "$ONLY_UC_DIR" || true

pushd "$ONLY_UC_DIR"

# proper dhcp-ed eth0
echo > ifcfg-eth0 'TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
ONBOOT=yes
'

# fake eth1
echo > ifcfg-eth1 'TYPE=Ethernet
DEVICE=eth1
ONBOOT=yes
'

sudo ip link add instack_only_uc type bridge || true

virt-builder "$INSTACK_DIST" \
    --output instack-only-uc.qcow2 \
    --format qcow2 \
    --size 30G \
    --hostname instack \
    --root-password password:stack \
    --run-command 'xfs_growfs / || true' \
    --upload "ifcfg-eth0:/etc/sysconfig/network-scripts/ifcfg-eth0" \
    --upload "ifcfg-eth1:/etc/sysconfig/network-scripts/ifcfg-eth1" \
    --mkdir /root/.ssh \
    --upload "$INSTACK_PUBLIC_KEY:/root/.ssh/authorized_keys" \
    --run-command 'chown -R root: /root/.ssh; chmod 0700 /root/.ssh; chmod 0600 /root/.ssh/authorized_keys' \
    --run-command 'setfiles -W -v /etc/selinux/targeted/contexts/files/file_contexts /root/.ssh'

sudo virt-install \
    --name instack-only-uc \
    --import \
    --disk ./instack-only-uc.qcow2 \
    --noautoconsole \
    --memory "$INSTACK_MEMORY" \
    --vcpus "$INSTACK_VCPUS" \
    --graphics spice \
    --video qxl \
    --channel spicevmc \
    --network "network=$INSTACK_NETWORK,model=virtio,mac=$INSTACK_MAC" \
    --network "bridge=instack_only_uc,model=virtio"

popd

echo -n "Waiting for instack VM's IP address..."
while true; do
    INSTACK_IP=$(cat /var/lib/libvirt/dnsmasq/default.leases | grep "$INSTACK_MAC" | awk '{ print $3 }' || true)
    if [ -n "$INSTACK_IP" ]; then
        echo
        echo "Instack machine IP is: $INSTACK_IP"
        echo > hosts.instack-only-uc "
[instack_only_uc]
$INSTACK_IP  ansible_ssh_user=root
"
        exit 0
    fi

    sleep 3
    echo -n "."
done
