#!/bin/bash
yum -y update

# PostgreSQL 9.5.x
yum -y install http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-redhat95-9.5-2.noarch.rpm
yum -y install postgresql95 postgresql95-contrib postgresql95-jdbc postgresql95-libs postgresql95-server

# PostgreSQL PATH
cat << __EOF__ > /etc/profile.d/postgresql.sh
#
export PATH=$PATH:/usr/pgsql-9.5/bin
__EOF__

source /etc/profile.d/postgresql.sh

# Configure Postgresql service for puppetdb
systemctl enable postgresql-9.5.service

# this code will be executed as a postgresql user
cat << __EOF__ | tee -a /tmp/config-postgresql-initdb.sh
/usr/pgsql-9.5/bin/initdb /var/lib/pgsql/9.5/data/
__EOF__

# Prepare the script for execution
chown postgres.postgres /tmp/config-postgresql-initdb.sh
su - postgres -c "source /tmp/config-postgresql-initdb.sh"

# remove temporal file
rm -rf /tmp/config-postgresql-initdb.sh

# Start PostgreSQL after initdb
systemctl start postgresql-9.5.service

# this code will be executed as a postgresql user
cat << __EOF__ | tee -a /tmp/config-postgresql-createdb.sh
psql -c "CREATE ROLE puppetdb WITH NOCREATEDB NOCREATEROLE NOSUPERUSER LOGIN PASSWORD 'puppetdbpwd';"
psql -c "CREATE DATABASE puppetdb WITH OWNER puppetdb ENCODING 'UTF8';"

# Neccesary extension
psql puppetdb -c "CREATE EXTENSION pg_trgm;"
__EOF__

# Prepare the script for execution
chown postgres.postgres /tmp/config-postgresql-createdb.sh
su - postgres -c "source /tmp/config-postgresql-createdb.sh"

# remove temporal file
rm -rf /tmp/config-postgresql-createdb.sh
