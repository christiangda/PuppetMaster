#!/bin/bash

################################################################################
# Set the hostname
hostnamectl set-hostname pa-01.puppet.local

################################################################################
# Install the puppet
yum -y update
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

################################################################################
# Install puppet agent
yum -y install puppet

################################################################################
# configure puppet path
cat << __EOF__ > /etc/profile.d/puppet.sh
#
export PATH=$PATH:/opt/puppetlabs/bin
__EOF__

source /etc/profile.d/puppet.sh

################################################################################
# Create custom fact for hiera hierarchy
mkdir -p /etc/puppetlabs/facter/facts.d/
echo '{ "node_group": "vagrant", "node_environment": "vagrant", "node_location": "vagrant" }' | tee /etc/puppetlabs/facter/facts.d/custom.json

################################################################################
#
puppet agent --enable
puppet agent --test --server ps.puppet.local --environment production --noop
sleep 5

################################################################################
#
cat << __EOF__ > /etc/puppetlabs/puppet/puppet.conf
[main]
server = ps.puppet.local
environment = production

[agent]
usecacheonfailure = false
__EOF__
