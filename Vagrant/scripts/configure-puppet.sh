#!/bin/bash

################################################################################
# Global VARs
PUPPET_CONF=/etc/puppetlabs/puppet/puppet.conf
PUPPETDB_CONF=/etc/puppetlabs/puppet/puppetdb.conf
FILESERVER_CONF=/etc/puppetlabs/puppet/fileserver.conf
AUTOSIGN_CONF=/etc/puppetlabs/puppet/autosign.conf
ROUTES_CONF=/etc/puppetlabs/puppet/routes.yaml
HIERA_CONF=/etc/puppetlabs/puppet/hiera.yaml

################################################################################
# file: puppet.conf
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
pluginsync=true

report=true
strict_environment_mode = true
strict_hostname_checking = true
strict_variables = true

[master]
server = master.puppet.local
dns_alt_names = master.puppet.local, master
reports = store,puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
environment_timeout = unlimited
__EOF__

################################################################################
# file: puppetdb.conf
cat << __EOF__ > $PUPPETDB_CONF
[main]
server_urls = https://master.puppet.local:8081
__EOF__

################################################################################
# file: fileserver.conf
cat << __EOF__ > $FILESERVER_CONF
[plugins]
  allow *

[modules]
  allow *
__EOF__

################################################################################
# file: autosign.conf
cat << __EOF__ > $AUTOSIGN_CONF
*.local
__EOF__

################################################################################
# file: routes.yaml
cat << __EOF__ > $ROUTES_CONF
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
__EOF__

################################################################################
# file: hiera.yaml
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
  :use_auth: false
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

################################################################################
# Install package to manage couchdb as hiera repo data
################################################################################
# Install package to manage couchdb as hiera repo data
/opt/puppetlabs/puppet/bin/gem install hiera-http
/opt/puppetlabs/puppet/bin/gem install deep_merge

################################################################################
# Set permmision
chown -R puppet:puppet `puppet config print confdir`
