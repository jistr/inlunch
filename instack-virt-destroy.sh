#!/bin/bash

set -euo pipefail

DIR=$(cd $(dirname "$BASH_SOURCE[0]") && pwd)
source "$DIR/lib/common.sh"

INLUNCH_HOSTS=$(get_hosts_file_path "$DIR/hosts.instack-virt.example")

echo "This is the hosts file being used:"
cat "$INLUNCH_HOSTS"
echo

read -p "Really destroy the instack setup there? ('y' to proceed) " ANSWER

if [ "$ANSWER" = 'y' ]; then
    ansible-playbook \
        -i "$INLUNCH_HOSTS" \
        "$@" \
        playbooks/instack_virt_destroy.yml
else
    echo "Not destroying anything."
fi
