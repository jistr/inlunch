inlunch
=======

Get an Instack environment prepared for you while you head out for
lunch.

Start up
--------

* Clone this repo *to your workstation*. Inlunch talks to hosts
  remotely using ssh.

  ```bash
  sudo yum -y install git ansible
  git clone https://github.com/rdo-management/inlunch
  cd inlunch
  ```

instack-virt.sh
---------------

This is deploying instack-virt-setup on the target host. You'll need a
reasonably powerful target host, and since instack-virt-setup is doing
moderately invasive operations on the host, you'll probably not want
to deploy it on your workstation. (You'll still run
`./instack-virt.sh` from your workstation, just make sure that the
`hosts` file points to a different machine.)

* Create an answer file to suit your needs, either by copying and
  amending the example one, or getting a ready one from a friend.

  ```bash
  cp answers.yml.example answers.yml
  # edit it manually
  ```

* Deploy!

  ```bash
  INLUNCH_FQDN=my-lab-machine.example.org ./instack-virt.sh
  ```

* Later, you can clean up your environment before re-deploying.

  ```bash
  INLUNCH_FQDN=my-lab-machine.example.org ./instack-virt-destroy.sh
  ```

### Tricks for instack-virt.sh

* After running `instack-virt.sh`, you can ssh to the host machine on
  port 2200 (e.g. `ssh -p 2200 root@my_instack_host`) to reach the
  undercloud VM directly.

* HTTP is forwarded from undercloud similarly as ssh. Pointing your
  browser to the host machine will let you access undercloud dashboard
  transparently.

* The script listens to `INLUNCH_ANSWERS` and `INLUNCH_HOSTS`
  environment variables, allowing you to customize answer/hosts file
  location. If you provide `INLUNCH_FQDN` variable, the scripts will
  use that host and you don't need to create a hosts file
  manually. E.g.:

  ```bash
  INLUNCH_ANSWERS=my_answers.yml INLUNCH_FQDN=my_machine.example.org ./instack-virt.sh
  ```
