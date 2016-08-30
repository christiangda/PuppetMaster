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
# Setup service
systemctl enable puppetdb.service
systemctl start puppetdb.service
