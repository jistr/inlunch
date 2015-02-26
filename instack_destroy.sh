#!/bin/bash

read -p "Really destroy the instack setup? ('y' to proceed) " ANSWER

if [ "$ANSWER" = 'y' ]; then
    ansible-playbook -i hosts \
        --extra-vars '@answers.yml' \
        "$@" \
        playbooks/instack_destroy.yml
fi
