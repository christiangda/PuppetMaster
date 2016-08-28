#!/bin/bash

################################################################################
# prepare requirements
yum -y update
yum -y install puppetdb-termini puppetdb

################################################################################
# add puppet to path
cat << __EOF__ > /etc/profile.d/puppet.sh
#
export PATH=$PATH:/opt/puppetlabs/bin
__EOF__

source /etc/profile.d/puppet.sh

################################################################################
# file: config.ini
cat << __EOF__ > /etc/puppetlabs/puppetdb/conf.d/config.ini
# See README.md for more thorough explanations of each section and
# option.

[global]
# Store mq/db data in a custom directory
vardir = /opt/puppetlabs/server/data/puppetdb

# Use an external logback config file
logging-config = /etc/puppetlabs/puppetdb/logback.xml

[command-processing]
# How many command-processing threads to use, defaults to (CPUs / 2)
threads = 1

# Maximum amount of disk space (in MB) to allow for ActiveMQ persistent message storage
store-usage = 102400

# Maximum amount of disk space (in MB) to allow for ActiveMQ temporary message storage
temp-usage = 51200
__EOF__

################################################################################
# file: database.ini
cat << __EOF__ > /etc/puppetlabs/puppetdb/conf.d/database.ini
[database]
# The database address, i.e. //HOST:PORT/DATABASE_NAME
subname = //localhost:5432/puppetdb

# Connect as a specific user
username = puppetdb

# Use a specific password
password = puppetdbpwd

# How often (in minutes) to compact the database
gc-interval = 60
__EOF__

################################################################################
# file: jetty.ini
cat << __EOF__ > /etc/puppetlabs/puppetdb/conf.d/jetty.ini
[jetty]
# IP address or hostname to listen for clear-text HTTP. To avoid resolution
# issues, IP addresses are recommended over hostnames.
# Default is `localhost`.
# host = <host>
host = 0.0.0.0

# Port to listen on for clear-text HTTP.
port = 8080

# The following are SSL specific settings. They can be configured
# automatically with the tool `puppetdb ssl-setup`, which is normally
# ran during package installation.

# IP address to listen on for HTTPS connections. Hostnames can also be used
# but are not recommended to avoid DNS resolution issues. To listen on all
# interfaces, use `0.0.0.0`.
ssl-host = 0.0.0.0

# The port to listen on for HTTPS connections
ssl-port = 8081

# Private key path
ssl-key = /etc/puppetlabs/puppetdb/ssl/private.pem

# Public certificate path
ssl-cert = /etc/puppetlabs/puppetdb/ssl/public.pem

# Certificate authority path
ssl-ca-cert = /etc/puppetlabs/puppetdb/ssl/ca.pem

# Access logging configuration path. To turn off access logging
# comment out the line with `access-log-config=...`
access-log-config = /etc/puppetlabs/puppetdb/request-logging.xml
__EOF__

################################################################################
# Prepare SSL
/opt/puppetlabs/server/apps/puppetdb/cli/apps/ssl-setup

################################################################################
# Setup service
systemctl enable puppetdb.service
systemctl start puppetdb.service
