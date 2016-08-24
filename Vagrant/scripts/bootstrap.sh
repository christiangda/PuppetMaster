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
127.0.0.1         localhost
192.168.33.100    master.puppet.local master
192.168.33.101    agent01.puppet.local agent01
192.168.33.102    agent02.puppet.local agent02
__EOF__

# Set hostname file (add lines)
cat << __EOF__ >> /etc/resolv.conf
# MANAGED BY boostrap.sh script in Vagrant
domain puppet.local
search puppet.local
__EOF__
