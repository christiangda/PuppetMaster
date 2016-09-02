#!/bin/bash

################################################################################
# build kernel module
/opt/VBoxGuestAdditions-5.0.24/init/vboxadd setup
/opt/VBoxGuestAdditions-5.0.24/init/vboxadd-service start

systemctl enable vboxadd.service
systemctl start vboxadd.service

################################################################################
# Compile and install CouchDB
#cd /usr/local/src
#http://download.virtualbox.org/virtualbox/5.1.4/VBoxGuestAdditions_5.1.4.iso
