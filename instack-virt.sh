#!/bin/bash

set -euo pipefail

DIR=$(cd $(dirname "$BASH_SOURCE[0]") && pwd)
source "$DIR/lib/common.sh"

INLUNCH_ANSWERS=$(get_answer_file_path)
INLUNCH_HOSTS=$(get_hosts_file_path "$DIR/hosts.instack-virt.example")
INLUNCH_PLAYBOOK=${INLUNCH_PLAYBOOK:-playbooks/instack_virt.yml}

ansible-playbook \
    -i "$INLUNCH_HOSTS" \
    --extra-vars "@$INLUNCH_ANSWERS" \
    "$@" \
    "$INLUNCH_PLAYBOOK"

remove_hosts_file_if_temporary "$INLUNCH_HOSTS"
