#!/bin/bash

################################################################################
#
sed -i 's/# host = <host>/host = 0.0.0.0/g' /etc/puppetlabs/puppetdb/conf.d/jetty.ini

################################################################################
# Prepare SSL
#/opt/puppetlabs/server/apps/puppetdb/cli/apps/ssl-setup
puppetdb ssl-setup -f

################################################################################
# Setup service
systemctl stop puppetdb.service
systemctl start puppetdb.service
