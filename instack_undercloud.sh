#!/bin/bash

ansible-playbook -i hosts \
    --extra-vars '@answers.yml' \
    "$@" \
    playbooks/instack_undercloud.yml