#!/bin/bash

set -euo pipefail

export OVERCLOUD_IMAGES_DIR=${OVERCLOUD_IMAGES_DIR:-"./overcloud-images"}
export OVERCLOUD_IMAGES_BASE_URL=${OVERCLOUD_IMAGES_BASE_URL:-"https://repos.fedorapeople.org/repos/openstack-m/tripleo-images-rdo-juno/"}

mkdir "$OVERCLOUD_IMAGES_DIR" || true
pushd "$OVERCLOUD_IMAGES_DIR"

wget -r --no-parent --no-host-directories --cut-dirs=100 --reject 'index.html*' "$OVERCLOUD_IMAGES_BASE_URL"

popd
