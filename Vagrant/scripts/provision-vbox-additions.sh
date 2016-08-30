#!/bin/bash

################################################################################
# Install requirements
yum -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r) dkms
/opt/VBoxGuestAdditions-5.0.24/init/vboxadd setup

################################################################################
# Compile and install CouchDB
#cd /usr/local/src
#http://download.virtualbox.org/virtualbox/5.1.4/VBoxGuestAdditions_5.1.4.iso
