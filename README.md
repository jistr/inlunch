Inlunch
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

Full instack-virt-setup
-----------------------

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
