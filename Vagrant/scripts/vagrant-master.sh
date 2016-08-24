#!/bin/bash
yum -y update
yum -y install puppetserver puppetdb-termini puppetdb

cat << __EOF__ >> /etc/profile.d/puppet.sh
#
export PATH=$PATH:/opt/puppetlabs/bin
__EOF__

source /etc/profile.d/puppet.sh

systemctl start puppetserver
systemctl enable puppetserver

#LIBS REQUIRE
puppet module install puppetlabs-stdlib
