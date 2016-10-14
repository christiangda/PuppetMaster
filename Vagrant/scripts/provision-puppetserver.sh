#!/bin/bash

################################################################################
# prepare requirements
#yum -y update
yum -y install puppetserver

################################################################################
# puppetlabs tools in the path
cat << __EOF__ > /etc/profile.d/puppet.sh
# Puppet's path
export PATH=$PATH:/opt/puppetlabs/bin
__EOF__

source /etc/profile.d/puppet.sh

################################################################################
# disable old auth
sed -i 's/#use-legacy-auth-conf: false/use-legacy-auth-conf: false/g' /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf

# Configure
#cp /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf.bkup
#cat << __EOF__ > /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf
#
#__EOF__

################################################################################
# setup services
systemctl enable puppetserver.service
systemctl start puppetserver.service
