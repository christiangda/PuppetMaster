#!/bin/bash

################################################################################
# Prepare the system
apt-get -y install linux-headers-$(uname -r) dkms
apt-get -y update
apt-get -y upgrade
apt-get -y autoremove
apt-get -y install vim htop elinks mlocate nmap telnet

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
