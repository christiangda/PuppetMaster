#!/bin/bash
yum -y update
yum -y install puppetmaster puppetdb-termini puppetdb

systemctl start puppetserver
systemctl enable puppetserver

#LIBS REQUIRE
puppet module install puppetlabs-stdlib
