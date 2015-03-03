#!/bin/bash

ansible-playbook -i hosts.instack-virt \
    --extra-vars '@answers.yml' \
    "$@" \
    playbooks/instack_virt.yml
