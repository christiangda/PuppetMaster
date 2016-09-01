#!/bin/bash

################################################################################
# Set the hostname
hostnamectl set-hostname agent-02.puppet.local

################################################################################
# remove old puppet
apt-get -y remove puppet
rm -rf /etc/puppet

################################################################################
# Install the puppet
apt-get -y update
apt-get -y autoremove
cd ~
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
dpkg -i puppetlabs-release-pc1-trusty.deb

################################################################################
# Install puppet agent
apt-get -y update
apt-get -y install puppet-agent

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
echo '{ "node_group": "vagrant", "node_environment": "vagrant", "location": "vagrant" }' | tee /etc/puppetlabs/facter/facts.d/custom.json

################################################################################
#
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

################################################################################
#
puppet agent --enable
puppet agent --test --server master.puppet.local --environment production --noop
sleep 5

################################################################################
#
cat << __EOF__ > /etc/puppetlabs/puppet/puppet.conf
#
[main]
server = master.puppet.local
environment = production
__EOF__
