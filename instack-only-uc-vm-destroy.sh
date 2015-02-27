#!/bin/bash

sudo virsh destroy instack-only-uc
sudo virsh undefine instack-only-uc --remove-all-storage
