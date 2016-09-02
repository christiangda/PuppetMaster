#!/bin/bash

################################################################################
# Install requirements
yum -y install epel-release
yum -y install autoconf autoconf-archive automake curl-devel erlang gcc-c++
yum -y install help2man js-devel libicu-devel libtool perl-Test-Harness unzip zip
yum -y install python-devel python-setuptools python-pip wget gem

################################################################################
# Install dependencies
pip install --upgrade pip
pip install -U Sphinx

################################################################################
# Install more dependencies
cd /usr/local/src
wget http://ftp.mozilla.org/pub/js/js185-1.0.0.tar.gz
tar -xvf js185-1.0.0.tar.gz
cd js-1.8.5/js/src/
./configure
make && sudo make install

################################################################################
# Compile and install CouchDB
cd /usr/local/src
wget http://www-us.apache.org/dist/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz
tar -xvf apache-couchdb-1.6.1.tar.gz
cd apache-couchdb-1.6.1
./configure --with-erlang=/usr/lib64/erlang/usr/include/
make && sudo make install

################################################################################
# Create user
useradd --no-create-home couchdb
chown -R couchdb:couchdb /usr/local/{lib,etc}/couchdb /usr/local/var/{lib,log,run}/couchdb

# permanent auto start
ln -sf /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb
chkconfig --add couchdb
chkconfig --level 2345 couchdb on

################################################################################
#
ln -s /usr/local/etc/couchdb /etc/couchdb
sed -i 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/g' /usr/local/etc/couchdb/default.ini

################################################################################
# start service
service couchdb start

################################################################################
# Neccesary to wait for CouchDB start
sleep 15

# Set user admin's passowrd
#curl -X PUT http://127.0.0.1:5984/_config/admins/admin -d '"admin"'

# Create defaults hiera hierarchy to test from the agent.puppet.local
# See: /etc/puppet/hiera.yaml
curl -X PUT http://127.0.0.1:5984/default -d '{}'
curl -X PUT http://127.0.0.1:5984/location/vagrant -d '{}'
curl -X PUT http://127.0.0.1:5984/vagrant/common -d '{}'
curl -X PUT http://127.0.0.1:5984/vagrant/vagrant -d '{}'
curl -X PUT http://127.0.0.1:5984/nodes -d '{}'
