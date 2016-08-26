#!/bin/bash

VM_HOSTNAME=$1

# Set the hostname
hostnamectl set-hostname $VM_HOSTNAME

# Install the puppet
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum --disablerepo=epel install puppet -y

cat << __EOF__ >> /etc/puppetlabs/puppet/puppet.conf
# This file can be used to override the default puppet settings.
# See the following links for more details on what settings are available:
# - https://docs.puppetlabs.com/puppet/latest/reference/config_important_settings.html
# - https://docs.puppetlabs.com/puppet/latest/reference/config_about_settings.html
# - https://docs.puppetlabs.com/puppet/latest/reference/config_file_main.html
# - https://docs.puppetlabs.com/puppet/latest/reference/configuration.html
[main]
certname = puppet-slave
server   = puppet-master.local


# Configure local puppet server
DEFAULT_AGENT_CONF=/etc/default/puppet
PUPPET_CONF=/etc/puppet/puppet.conf

__EOF__


# Set puppetmaster server (running as root user)
systemctl enable puppet
systemctl start puppet

#BY PUPPET
puppet agent --enable
puppet agent -t --noop
puppet resource service puppet ensure=running enable=true
