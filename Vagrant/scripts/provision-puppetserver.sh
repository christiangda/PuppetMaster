#!/bin/bash
yum -y update
yum -y install puppetserver

#
cat << __EOF__ > /etc/profile.d/puppet.sh
#
export PATH=$PATH:/opt/puppetlabs/bin
__EOF__

source /etc/profile.d/puppet.sh

# Configure
#cp /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf.bkup
#cat << __EOF__ > /etc/puppetlabs/puppetserver/conf.d/puppetserver.conf
#
#__EOF__

systemctl enable puppetserver.service
systemctl start puppetserver.service

# Require modules
# puppet module install puppetlabs-stdlib
# puppet module install puppetlabs-registry
# puppet module install puppetlabs-motd
# puppet module install puppetlabs-inifile
# puppet module install puppetlabs-postgresql
# puppet module install puppetlabs-apt
# puppet module install puppetlabs-concat
# puppet module install puppetlabs-puppetdb
# puppet module install puppetlabs-ntp
# puppet module install puppetlabs-java
