inlunch
=======

Get an Instack environment prepared for you while you head out for
lunch.

Start up
--------

* Clone this repo *to your workstation*. Inlunch talks to hosts
  remotely using ssh.

  ```bash
  rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm 
  sudo yum -y install git ansible
  git clone https://github.com/jistr/inlunch
  cd inlunch
  ```
  In case of using Inlunch in the same physical node in which the
  undercloud will be deployed, add the public key of the current
  user to his authorized_hosts file.

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
  port 2200 (e.g. `ssh -p 2200 stack@my_instack_host`) to reach the
  undercloud VM directly. You can ssh as `root` user too, but most of
  the time you'll want to work with the undercloud as `stack` user.

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

### Deploying an overcloud
  
* After installing the undercloud an overcloud might be deployed.

  Clone the tripleo-heat-templates repository if used THT from sources:
  
    ```bash
  git clone https://github.com/openstack/tripleo-heat-templates
  ```
  Then deploy the overcloud:
  
  ```bash
  openstack overcloud deploy \
  --libvirt-type qemu \
  --ntp-server pool.ntp.org \
  --templates /home/stack/tripleo-heat-templates \
  -e /home/stack/tripleo-heat-templates/overcloud-resource-registry-puppet.yaml \
  -e /home/stack/tripleo-heat-templates/environments/puppet-pacemaker.yaml
  ```
  Note that this overcloud deployment uses the tripleo-heat-templates repository
  from sources. So forth the repository must be cloned first.

  For further information related to how to deploy tripleo, refer
  to [tripleo.org](http://www.tripleo.org) official documentation website.
