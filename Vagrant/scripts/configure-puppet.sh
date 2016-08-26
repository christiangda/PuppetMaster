#!/bin/bash
PUPPET_CONF=/etc/puppetlabs/puppet/puppet.conf
FILESERVER_CONF=/etc/puppetlabs/puppet/fileserver.conf
AUTOSIGN_CONF=/etc/puppetlabs/puppet/autosign.conf
ROUTES_CONF=/etc/puppetlabs/puppet/routes.yaml
HIERA_CONF=/etc/puppetlabs/puppet/hiera.yaml


################################################################################
# puppet.conf
#
cp $PUPPET_CONF $PUPPET_CONF.bkup
cat << __EOF__ > $PUPPET_CONF
[main]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code

certname = master.puppet.local
server = master.puppet.local
dns_alt_names = master,master.puppet.local
environment = production
runinterval = 1h

report=true
strict_environment_mode = true
strict_hostname_checking = true
strict_variables = true

[master]
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
environment_timeout = unlimited
__EOF__

################################################################################
# fileserver.conf
#
cp $FILESERVER_CONF $FILESERVER_CONF.bkup
cat << __EOF__ > $FILESERVER_CONF
[plugins]
  allow *

[modules]
  allow *
__EOF__

################################################################################
# autosign.conf
#
cp $AUTOSIGN_CONF $AUTOSIGN_CONF.bkup
cat << __EOF__ > $AUTOSIGN_CONF
*.local
__EOF__

################################################################################
# routes.yaml
#
cp $ROUTES_CONF $ROUTES_CONF.bkup
cat << __EOF__ > $ROUTES_CONF
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
__EOF__

################################################################################
# hiera.yaml
#
cp $HIERA_CONF $HIERA_CONF.bkup
cat << __EOF__ > $HIERA_CONF
---
:backends:
  - http
  - yaml
  - json

:yaml:
  :datadir: "/etc/puppetlabs/code/environments/%{::environment}/hieradata"

:json:
  :datadir: "/etc/puppetlabs/code/environments/%{::environment}/hieradata"

:hierarchy:
  - "nodes/%{::clientcert}"
  - "%{::node_group}/%{::node_environment}"
  - "%{::node_group}/common"
  - "location/%{::node_location}"
  - "common"

:http:
  :host: 127.0.0.1
  :port: 5984
  :use_auth: true
  :auth_user: admin
  :auth_pass: admin
  :output: json
  :failure: graceful
  :paths:
    - /hieradata/nodes/%{::clientcert}
    - /hieradata/%{::node_group}/%{::node_environment}
    - /hieradata/%{::node_group}/common
    - /hieradata/location/%{::node_location}
    - /hieradata/common

:merge_behavior: deeper

:logger: console

__EOF__
