#!/bin/bash

################################################################################
# Create custom fact for hiera hierarchy
mkdir -p /etc/puppetlabs/facter/facts.d/
echo '{ "node_group": "vagrant", "node_environment": "vagrant", "node_location": "vagrant" }' | tee /etc/puppetlabs/facter/facts.d/custom.json

################################################################################
#
puppet agent --enable
puppet agent --test --server master.puppet.local --environment production --noop
