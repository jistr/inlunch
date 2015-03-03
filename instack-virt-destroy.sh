#!/bin/bash

read -p "Really destroy the instack setup? ('y' to proceed) " ANSWER

if [ "$ANSWER" = 'y' ]; then
    ansible-playbook -i hosts.instack-virt \
        --extra-vars '@answers.yml' \
        "$@" \
        playbooks/instack_virt_destroy.yml
fi
