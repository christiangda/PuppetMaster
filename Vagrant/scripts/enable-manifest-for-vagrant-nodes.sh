#!/bin/bash

################################################################################
# Global VARs
VAGRANT_MANIFEST=/etc/puppetlabs/code/environments/production/manifests/01_only_vagrant.pp
VAGRANT_GITIGNORE=/etc/puppetlabs/code/environments/production/manifests/.gitignore

if [ ! -f $VAGRANT_GITIGNORE ]; then
cat << __EOF__ > $VAGRANT_GITIGNORE
# Ignore itself
.gitignore

# Ignore Our node file for vagrant
01_only_vagrant.pp
__EOF__
fi

################################################################################
# Add manifest for vagrant nodes
if [ ! -f $VAGRANT_MANIFEST ]; then
cat << __EOF__ > $VAGRANT_MANIFEST
################################################################################
# NODES DEFINITION
node 'master.puppet.local' {
  include profile::common

}

node 'agent-01.puppet.local' {
  include profile::common

}

node 'agent-02.puppet.local' {
  include profile::common

}
__EOF__
fi
