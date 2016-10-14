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
wget http://www-us.apache.org/dist/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz
tar -xvf apache-couchdb-2.0.0.tar.gz
cd apache-couchdb-2.0.0
./configure
make release

################################################################################
# Create user
adduser --system --create-home --shell /bin/bash --user-group couchdb
cd /usr/local/src/apache-couchdb-2.0.0
cp -R rel/couchdb /home/couchdb/
chown -R couchdb:couchdb /home/couchdb/
find /home/couchdb/ -type d -exec chmod 0770 {} \;
chmod 0644 /home/couchdb/couchdb/etc/*

cat > /etc/profile.d/couchdb.sh << _EOF
export PATH=\$PATH:/home/couchdb/couchdb/bin
_EOF
source /etc/profile.d/couchdb.sh

################################################################################
# prepare setting
# start couchdb to configure default databases
sudo -i -u couchdb couchdb/bin/couchdb > /dev/null 2>&1 &
sleep 60

# Create defaults databases
curl -X PUT http://127.0.0.1:5984/_users
curl -X PUT http://127.0.0.1:5984/_replicator
curl -X PUT http://127.0.0.1:5984/_global_changes

# stop couchdb after setting
pkill -u couchdb


# permanent auto start
cat > /lib/systemd/system/couchdb.service << _EOF
[Unit]
Description=the system-wide CouchDB instance
After=network.target

[Service]
Type=simple
User=couchdb
Group=couchdb
#ExecStart=/bin/su - couchdb couchdb/bin/couchdb &
ExecStart=/home/couchdb/couchdb/bin/couchdb
PIDFile=/run/couchdb/couchdb.pid
ExecStop=pkill -u couchdb

[Install]
WantedBy=multi-user.target
_EOF

touch /home/couchdb/couchdb/var/log/couch.log
chown couchdb.couchdb /home/couchdb/couchdb/var/log/couch.log
ln -sf /lib/systemd/system/couchdb.service /etc/systemd/system/couchdb.service
ln -s /home/couchdb/couchdb/etc /etc/couchdb
ln -s /home/couchdb/couchdb/var/log /var/log/couchdb
sed -i 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/g' /home/couchdb/couchdb/etc/default.ini
sed -i '/\[log\]/a file \= \/home\/couchdb\/couchdb\/var\/log\/couch\.log' /home/couchdb/couchdb/etc/default.ini

################################################################################
# start service
systemctl enable couchdb.service
systemctl start couchdb.service

sleep 60

# Set user admin's passowrd
#curl -X PUT http://127.0.0.1:5984/_config/admins/admin -d '"admin"'

# Create defaults hiera hierarchy to test from the agent.puppet.local
# See: /etc/puppet/hiera.yaml
curl -X PUT http://127.0.0.1:5984/default -d '{}'
curl -X PUT http://127.0.0.1:5984/default/common -d '{
   "profile::common::packages::redhat_family": [
       "nmap"
   ],
   "profile::common::motd::content": "         hostname: %{::fqdn}\n       node_group: %{::node_group}\n node_environment: %{::node_environment}\n    node_location: %{::node_location}\n       puppet env: %{::environment}\n\n",
   "profile::common::packages::debian_family": [
       "nmap"
   ]
}'
curl -X PUT http://127.0.0.1:5984/location -d '{}'
curl -X PUT http://127.0.0.1:5984/location/vagrant -d '{
   "profile::common::packages::redhat_family": [
       "git"
   ],
   "profile::common::packages::debian_family": [
       "git"
   ]
}'
curl -X PUT http://127.0.0.1:5984/vagrant -d '{}'
curl -X PUT http://127.0.0.1:5984/vagrant/common -d '{}'
curl -X PUT http://127.0.0.1:5984/vagrant/vagrant -d '{}'
curl -X PUT http://127.0.0.1:5984/nodes -d '{}'
