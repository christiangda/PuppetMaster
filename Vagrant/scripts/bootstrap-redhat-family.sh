#!/bin/bash

################################################################################
# Prepare the system
#yum -y install deltarpm
#yum -y install kernel-devel kernel-headers dkms
#yum -y update
yum -y install vim-enhanced htop elinks mlocate nmap telnet
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

################################################################################
# Disable selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/SELINUXTYPE=minimum/g' /etc/selinux/config
setenforce 0

################################################################################
# Enter like root all time
cat << __EOF__ >> /home/vagrant/.profile
#
# Autologin as root
# Added by vagrant-agent.sh script
sudo su -
__EOF__
chown vagrant.vagrant /home/vagrant/.profile
echo "" >> /home/vagrant/.bash_profile
echo "source ~/.profile" >> /home/vagrant/.bash_profile

################################################################################
# Set hostname file (replaced)
cat << __EOF__ > /etc/hosts
# MANAGED BY boostrap.sh script in Vagrant
127.0.0.1         localhost
192.168.33.100    master.puppet.local master
192.168.33.101    agent-01.puppet.local agent-01
192.168.33.102    agent-02.puppet.local agent-02
__EOF__

################################################################################
# Set hostname file (add lines)
cat << __EOF__ >> /etc/resolv.conf
# MANAGED BY boostrap.sh script in Vagrant
domain puppet.local
search puppet.local
__EOF__
