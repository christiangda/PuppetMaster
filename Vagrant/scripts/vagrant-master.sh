#!/bin/bash

# Set the hostname
#hostnamectl set-hostname master.puppet.local

# Install the puppetmaster
apt-get -y update
apt-get -y install puppet puppetmaster puppetdb puppetdb-terminus
apt-get -y autoremove

service puppetmaster stop
apt-get -y install puppetmaster-passenger

# Fixing puppetdb autostart scripts
# it doesn't work with update-rc.d puppetdb enable at first time
cd /etc/rc2.d/; ln -s ../init.d/puppetdb S20puppetdb
cd /etc/rc3.d/; ln -s ../init.d/puppetdb S20puppetdb
cd /etc/rc4.d/; ln -s ../init.d/puppetdb S20puppetdb
cd /etc/rc5.d/; ln -s ../init.d/puppetdb S20puppetdb
update-rc.d puppetdb enable 2345

# Configuring limits for puppetdb files
echo "store-usage = 102400" >> /etc/puppetdb/conf.d/config.ini
echo "temp-usage = 102400" >> /etc/puppetdb/conf.d/config.ini
sed -i '/# Port/ihost = 0.0.0.0' /etc/puppetdb/conf.d/jetty.ini

# Installing CoauhDB (hiera datastore)
add-apt-repository -y ppa:couchdb/stable
apt-get -y update
apt-get -yf remove couchdb couchdb-bin couchdb-common
apt-get -y install couchdb
stop couchdb
sed -i 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/g' /etc/couchdb/default.ini
sudo chown -R couchdb:couchdb /usr/lib/couchdb /usr/share/couchdb /etc/couchdb /usr/bin/couchdb
sudo chmod -R 0770 /usr/lib/couchdb /usr/share/couchdb /etc/couchdb /usr/bin/couchdb
start couchdb

# Neccesary to wait for CouchDB start
sleep 15

# Set user admin's passowrd
curl -X PUT http://127.0.0.1:5984/_config/admins/admin -d '"admin"'

# Create defaults hiera hierarchy to test from the agent.puppet.local
# See: /etc/puppet/hiera.yaml
curl -X PUT http://admin:admin@127.0.0.1:5984/defaults
curl -X PUT http://admin:admin@127.0.0.1:5984/location
curl -X PUT http://admin:admin@127.0.0.1:5984/group_vagrant
curl -X PUT http://admin:admin@127.0.0.1:5984/nodes

# Put common document in default database
curl -X PUT http://admin:admin@127.0.0.1:5984/defaults/common -d '{"default_common_variable":"variable @ /default/common hiera hierarchy!", "default_common_array":["array @ /default/common hiera hierarchy!"], "default_common_hash":{ "key":"hash @ /default/common hiera hierarchy!"}}'

# Put location fact document in location database
curl -X PUT http://admin:admin@127.0.0.1:5984/location/vagrant -d '{"location_vagrant_variable":"variable @ /location/vagrant hiera hierarchy!", "location_vagrant_array":["array @ /location/vagrant hiera hierarchy!"], "location_vagrant_hash":{ "key":"hash @ /location/vagrant hiera hierarchy!"}}'

# This documments works thanks to fact in agent.puppets.local
# see: vagrant-agent.sh
curl -X PUT http://admin:admin@127.0.0.1:5984/group_vagrant/common -d '{"group_vagrant_common_variable":"variable @ /group_vagrant/common hiera hierarchy!", "group_vagrant_common_array":["array @ /group_vagrant/common hiera hierarchy!"], "group_vagrant_common_hash":{ "key":"hash @ /group_vagrant/common hiera hierarchy!"}}'
curl -X PUT http://admin:admin@127.0.0.1:5984/group_vagrant/env_vagrant -d '{"group_vagrant_env_vagrant_variable":"variable @ /group_vagrant/env_vagrant hiera hierarchy!", "group_vagrant_env_vagrant_array":["array @ /group_vagrant/env_vagrant hiera hierarchy!"], "group_vagrant_env_vagrant_hash":{ "key":"hash @ /group_vagrant/env_vagrant hiera hierarchy!"}}'

# This documment works thanks to the certname in the client
curl -X PUT http://admin:admin@127.0.0.1:5984/nodes/client_agent01.puppet.local -d '{"nodes_client_agent01.puppet.local_variable":"variable @ /nodes/client_agent01.puppet.local hiera hierarchy!", "nodes_client_agent01.puppet.local_array":["array @ /nodes/client_agent01.puppet.local hiera hierarchy!"], "nodes_client_agent01.puppet.local_hash":{ "key":"hash @ /nodes/client_agent01.puppet.local hiera hierarchy!"}}'
curl -X PUT http://admin:admin@127.0.0.1:5984/nodes/client_agent02.puppet.local -d '{"nodes_client_agent02.puppet.local_variable":"variable @ /nodes/client_agent02.puppet.local hiera hierarchy!", "nodes_client_agent02.puppet.local_array":["array @ /nodes/client_agent02.puppet.local hiera hierarchy!"], "nodes_client_agent02.puppet.local_hash":{ "key":"hash @ /nodes/client_agent02.puppet.local hiera hierarchy!"}}'

# Installing hiera-http backend
apt-get -y install ruby-dev ruby2.0
gem install hiera-http
gem install deep_merge

# Configure local puppet server
DEFAULT_MASTER_CONF=/etc/default/puppetmaster
DEFAULT_AGENT_CONF=/etc/default/puppet
PUPPET_CONF=/etc/puppet/puppet.conf
PUPPETDB_CONF=/etc/puppet/puppetdb.conf
FILESERVER_CONF=/etc/puppet/fileserver.conf
AUTOSIGN_CONF=/etc/puppet/autosign.conf
ROUTES_CONF=/etc/puppet/routes.yaml
HIERA_CONF=/etc/puppet/hiera.yaml

########################################################################################################################
# Rendering default master conf
cat << __EOF__ > $DEFAULT_MASTER_CONF
# Defaults for puppetmaster - sourced by /etc/init.d/puppetmaster

# Enable puppetmaster service?
# Setting this to "yes" allows the puppet master service to run.
# Setting this to "no" keeps the puppet master service from running.
#
# If you are using Passenger, you should have this set to "no."
START=no

# Startup options
DAEMON_OPTS=""

# On what port should the puppet master listen? (default: 8140)
PORT=8140
LANG=en_US.UTF-8

__EOF__

########################################################################################################################
# Rendering default agent conf
cat << __EOF__ > $DEFAULT_AGENT_CONF
# Defaults for puppet - sourced by /etc/init.d/puppet

# Start puppet on boot?
START=no

# Startup options
DAEMON_OPTS=""

__EOF__

########################################################################################################################
# Rendering puppet.conf
cat << __EOF__ > $PUPPET_CONF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=\$vardir/lib/facter
certificate_revocation = false
report=true
certname=master.puppet.local
server=master.puppet.local
dns_alt_names=master.puppet.local, master

[master]
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY
environmentpath = \$confdir/environments
storeconfigs = true
storeconfigs_backend = puppetdb
reports = puppetdb

__EOF__

########################################################################################################################
# Rendering puppetdb.conf
cat << __EOF__ > $PUPPETDB_CONF
[main]
port = 8081
soft_write_failure = false
server = master.puppet.local

__EOF__

########################################################################################################################
# Rendering fileserver.conf
cat << __EOF__ > $FILESERVER_CONF
[plugins]

[modules]
  allow *
__EOF__

########################################################################################################################
# Rendering autosign.conf
cat << __EOF__ > $AUTOSIGN_CONF
*.local
__EOF__

########################################################################################################################
# Rendering routes.yaml
cat << __EOF__ > $ROUTES_CONF
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
__EOF__

########################################################################################################################
# Rendering hiera.yaml
cat << __EOF__ > $HIERA_CONF
---
:backends:
  - http

:http:
  :host: 127.0.0.1
  :port: 5984
  :use_auth: true
  :auth_user: admin
  :auth_pass: admin
  :output: json
  :failure: graceful
  :paths:
    - /nodes/client_%{::clientcert}
    - /group_%{::node_group}/env_%{::node_environment}
    - /group_%{::node_group}/common
    - /location/%{::location}
    - /defaults/common

:merge_behavior: deeper
__EOF__


# Restart apache passenger service to refresh changes
/etc/init.d/apache2 restart
