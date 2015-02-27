#!/bin/bash

ansible-playbook -i hosts.instack-only-uc \
    --extra-vars '@answers.yml' \
    "$@" \
    playbooks/instack_only_uc.yml
