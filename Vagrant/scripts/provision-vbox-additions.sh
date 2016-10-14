#!/bin/bash
################################################################################
# install dependencies
yum -y install gcc make

################################################################################
# build kernel module
/opt/VBoxGuestAdditions-5.1.6/init/vboxadd setup
/opt/VBoxGuestAdditions-5.1.6/init/vboxadd-service start

systemctl enable vboxadd-service.service
systemctl enable vboxadd-x11.service
systemctl enable vboxadd.service

systemctl start vboxadd.service

################################################################################
# Compile and install VBoxGuestAdditions
cd /usr/local/src
wget http://download.virtualbox.org/virtualbox/5.1.6/VBoxGuestAdditions_5.1.6.iso
mount VBoxGuestAdditions_5.1.6.iso -o loop /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
rm -rf *.iso
