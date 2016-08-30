#!/bin/bash
################################################################################
# Prepare SSL
/opt/puppetlabs/server/apps/puppetdb/cli/apps/ssl-setup

################################################################################
# Setup service
systemctl stop puppetdb.service
systemctl start puppetdb.service
