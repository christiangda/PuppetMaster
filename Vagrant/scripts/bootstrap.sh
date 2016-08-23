#!/bin/bash

# Prepare the system
yum -y update
yum -y install vim htop elinks
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

# Enter like root all time
cat << __EOF__ >> /home/vagrant/.profile
#
# Autologin as root
# Added by vagrant-agent.sh script
sudo su -
__EOF__
chown vagrant.vagrant /home/vagrant/.profile

# Set hostname file (replaced)
cat << __EOF__ > /etc/hosts
# MANAGED BY boostrap.sh script in Vagrant
127.0.0.1   localhost
10.0.2.2    puppetmaster.local puppetmaster
10.0.2.3    agent01.local agent01

__EOF__

# Set hostname file (add lines)
cat << __EOF__ >> /etc/resolv.conf
# MANAGED BY boostrap.sh script in Vagrant
domain local
search local
__EOF__
