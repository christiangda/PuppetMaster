#!/bin/bash

# Prepare the system
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y install software-properties-common htop nmap elinks

# add puppet repositories
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
rm -rf puppetlabs-release-trusty.deb

# better for puppetdb
#wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
#dpkg -i puppetlabs-release-pc1-trusty.deb
#apt-get update
#rm -rf puppetlabs-release-pc1-trusty.deb

# Disable other services
update-rc.d chef-client disable

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
