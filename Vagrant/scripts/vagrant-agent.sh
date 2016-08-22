#!/bin/bash

VM_HOSTNAME=$1

# Set the hostname
#hostnamectl set-hostname $VM_HOSTNAME

# Install the puppet
apt-get -y update
apt-get -y install puppet
service puppet stop

# Create custom fact for hiera hierarchy
mkdir -p /etc/facter/facts.d
echo '{ "node_group": "vagrant", "node_environment": "vagrant", "location": "vagrant" }' | tee /etc/facter/facts.d/custom.json

# Configure local puppet server
DEFAULT_AGENT_CONF=/etc/default/puppet
PUPPET_CONF=/etc/puppet/puppet.conf

########################################################################################################################
# Rendering default agent conf
cat << __EOF__ > $DEFAULT_AGENT_CONF
# Defaults for puppet - sourced by /etc/init.d/puppet

# Start puppet on boot?
START=no

# Startup options
DAEMON_OPTS=""

__EOF__

########################################################################################################################
# Rendering puppet.conf
cat << __EOF__ > $PUPPET_CONF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=\$vardir/lib/facter
pluginsync=true
report=true
certname=$VM_HOSTNAME
server=master.puppet.local

__EOF__

# Set puppetmaster server (running as root user)
puppet agent --enable
puppet agent -t --noop
