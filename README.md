inlunch
=======

Get an Instack environment prepared for you while you head out for
lunch.

Start up
--------

* Clone this repo *to your workstation*. Inlunch talk to hosts
  remotely using ssh.

  ```bash
  git clone https://github.com/jistr/inlunch
  cd inlunch
  ```

* If you'll want to use pre-built overcloud images, download them.

  ```bash
  ./download_overcloud_images.sh
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
  cp hosts.example hosts
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
  ./instack_virt.sh
  ```

* Later, you can clean up your environment before re-deploying.

  ```bash
  ./instack_virt_destroy.sh
  ```
