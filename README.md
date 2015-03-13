inlunch
=======

Get an Instack environment prepared for you while you head out for
lunch.

Start up
--------

* Clone this repo *to your workstation*. Inlunch talks to hosts
  remotely using ssh.

  ```bash
  sudo yum -y install git ansible
  git clone https://github.com/rdo-management/inlunch
  cd inlunch
  ```

* If you'll want to use pre-built overcloud images, download them.

  ```bash
  ./download-overcloud-images.sh
  ```

instack-virt.sh
---------------

This is deploying instack-virt-setup on the target host. You'll need a
reasonably powerful target host, and since instack-virt-setup is doing
moderately invasive operations on the host, you'll probably not want
to deploy it on your workstation. (You'll still run
`./instack-virt.sh` from your workstation, just make sure that the
`hosts` file points to a different machine.)

* Set up hosts file. You can copy the example one and change the
  machine FQDN there.

  ```bash
  cp hosts.instack-virt.example hosts.instack-virt
  # edit it manually
  ```

* Create an answer file to suit your needs, either by copying and
  amending the example one, or getting a ready one from a friend.

  ```bash
  cp answers.yml.example answers.yml
  # edit it manually
  ```

* Deploy!

  ```bash
  ./instack-virt.sh
  ```

* Later, you can clean up your environment before re-deploying.

  ```bash
  ./instack-virt-destroy.sh
  ```

### Tricks for instack-virt.sh

* After running `instack-virt.sh`, you can ssh to the host machine on
  port 2200 (e.g. `ssh -p 2200 root@my_instack_host`) to reach the
  undercloud VM directly.

* HTTP is forwarded from undercloud similarly as ssh. Pointing your
  browser to the host machine will let you access undercloud dashboard
  transparently.

* The script listens to `INLUNCH_ANSWERS` and `INLUNCH_HOSTS`
  environment variables, allowing you to customize answer/hosts file
  location. If you provide `INLUNCH_FQDN` variable, the scripts will
  use that host and you don't need to create a hosts file manually.

instack-only-uc.sh
------------------

This is deploying only undercloud (no overcloud nodes) directly on a
particular target host. Can be used to quickly get a local VM on the
workstation with a running undercloud. `instack-only-uc-vm-create.sh`
and `instack-only-uc-vm-destroy.sh` can create and remove the VM for
you. The aim was to make them as unobtrusive as possible, but read
them to see what they do to your workstation before using them.

* Create the VM. This will also overwrite `hosts.instack-only-uc` file
  with the IP of the newly created VM, so that you don't have to edit
  it manually.

  ```bash
  INSTACK_DIST=fedora20 ./instack-only-uc-vm-create.sh
  ```

* Create an answer file to suit your needs, either by copying and
  amending the example one, or getting a ready one from a friend.

  ```bash
  cp answers.yml.example answers.yml
  # edit it manually
  ```

* Deploy!

  ```bash
  ./instack-only-uc.sh
  ```

* When you don't need it anymore, destroy the VM.

  ```bash
  ./instack-only-uc-vm-destroy.sh
  ```
  Now you can run `./instack-only-uc-vm-create.sh` again.

  If you wish to clean up your system completely, remove the bridge
  and libvirt storage pool.

  ```bash
  sudo ip link del instack_only_uc type bridge
  sudo virsh pool-destroy instack-only-uc
  sudo virsh pool-undefine instack-only-uc
  ```
