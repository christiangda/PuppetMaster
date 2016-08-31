#!/bin/bash

################################################################################
# Set the hostname
hostnamectl set-hostname agent-01.puppet.local

################################################################################
# Install the puppet
yum -y update
yum -y install vim htop elinks mlocate
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
mkdir -p /etc/facter/facts.d
echo '{ "node_group": "vagrant", "node_environment": "vagrant", "location": "vagrant" }' | tee /etc/facter/facts.d/custom.json


################################################################################
#
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

################################################################################
#
puppet agent --enable
puppet agent --test --server master.puppet.local --environment production --noop
