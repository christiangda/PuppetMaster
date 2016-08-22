#!/bin/bash

# Configure local puppet server

PMAGENT_NODE_CONF=/etc/puppet/environments/production/manifests/00_only_vagrant.pp
PMAGENT_GITIGNORE_CONF=/etc/puppet/environments/production/manifests/.gitignore

if [ ! -f $PMAGENT_GITIGNORE_CONF ]; then
########################################################################################################################
# Rendering 00_only_vagrant.pp
cat << __EOF__ > $PMAGENT_GITIGNORE_CONF
# Ignore itself
.gitignore

# Ignore Our node file for vagrant
00_only_vagrant.pp

__EOF__

fi

if [ ! -f $PMAGENT_NODE_CONF ]; then
########################################################################################################################
# Rendering .gitignore
cat << __EOF__ > $PMAGENT_NODE_CONF
########################################################################################################################
# NODE
node 'agent01.puppet.local' {
  # Is working!
  notify { 'The node definition is working at manifests/00_only_vagrant.pp': message => "Node: \${::fqdn}", } ->
  #
  notify { 'test 01': message => hiera('default_common_variable'); } ->
  notify { 'test 02': message => hiera_array('default_common_array'); } ->
  notify { 'test 03': message => hiera_hash('default_common_hash'); } ->
  #
  notify { 'test 04': message => hiera('location_vagrant_variable'); } ->
  notify { 'test 05': message => hiera_array('location_vagrant_array'); } ->
  notify { 'test 06': message => hiera_hash('location_vagrant_hash'); } ->
  #
  notify { 'test 07': message => hiera('group_vagrant_common_variable'); } ->
  notify { 'test 08': message => hiera_array('group_vagrant_common_array'); } ->
  notify { 'test 09': message => hiera_hash('group_vagrant_common_hash'); } ->
  #
  notify { 'test 10': message => hiera('group_vagrant_env_vagrant_variable'); } ->
  notify { 'test 11': message => hiera_array('group_vagrant_env_vagrant_array'); } ->
  notify { 'test 12': message => hiera_hash('group_vagrant_env_vagrant_hash'); } ->
  #
  notify { 'test 13': message => hiera('nodes_client_agent01.puppet.local_variable'); } ->
  notify { 'test 14': message => hiera_array('nodes_client_agent01.puppet.local_array'); } ->
  notify { 'test 15': message => hiera_hash('nodes_client_agent01.puppet.local_hash'); }

  ######################################################################################################################
  # your code here
  include motd

}

node 'agent02.puppet.local' {
  # Is working!
  notify { 'The node definition is working at manifests/00_only_vagrant.pp': message => "Node: \${::fqdn}", } ->
  #
  notify { 'test 01': message => hiera('default_common_variable'); } ->
  notify { 'test 02': message => hiera_array('default_common_array'); } ->
  notify { 'test 03': message => hiera_hash('default_common_hash'); } ->
  #
  notify { 'test 04': message => hiera('location_vagrant_variable'); } ->
  notify { 'test 05': message => hiera_array('location_vagrant_array'); } ->
  notify { 'test 06': message => hiera_hash('location_vagrant_hash'); } ->
  #
  notify { 'test 07': message => hiera('group_vagrant_common_variable'); } ->
  notify { 'test 08': message => hiera_array('group_vagrant_common_array'); } ->
  notify { 'test 09': message => hiera_hash('group_vagrant_common_hash'); } ->
  #
  notify { 'test 10': message => hiera('group_vagrant_env_vagrant_variable'); } ->
  notify { 'test 11': message => hiera_array('group_vagrant_env_vagrant_array'); } ->
  notify { 'test 12': message => hiera_hash('group_vagrant_env_vagrant_hash'); } ->
  #
  notify { 'test 13': message => hiera('nodes_client_agent02.puppet.local_variable'); } ->
  notify { 'test 14': message => hiera_array('nodes_client_agent02.puppet.local_array'); } ->
  notify { 'test 15': message => hiera_hash('nodes_client_agent02.puppet.local_hash'); }

  ######################################################################################################################
  # your code here
  include motd

}
__EOF__

fi
