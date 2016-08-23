#!/bin/bash
yum --disablerepo=epel install puppetmaster -y


sudo sh -c "ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet"

cat << __EOF__ >> /etc/sysconfig/puppetserver
###########################################
# Init settings for puppetserver
###########################################

# Location of your Java binary (version 7 or higher)
JAVA_BIN="/usr/bin/java"

# Modify this if you'd like to change the memory allocation, enable JMX, etc
JAVA_ARGS="-Xms1536m -Xmx1536m -XX:MaxPermSize=256m"

# These normally shouldn't need to be edited if using OS packages
USER="puppet"
GROUP="puppet"
INSTALL_DIR="/opt/puppetlabs/server/apps/puppetserver"
CONFIG="/etc/puppetlabs/puppetserver/conf.d"

# Bootstrap path
BOOTSTRAP_CONFIG="/etc/puppetlabs/puppetserver/services.d/,/opt/puppetlabs/server/apps/puppetserver/config/services.d/"

SERVICE_STOP_RETRIES=60

# START_TIMEOUT can be set here to alter the default startup timeout in
# seconds.  This is used in System-V style init scripts only, and will have no
# effect in systemd.
# START_TIMEOUT=300
__EOF__

systemctl start puppetserver 
systemctl enable puppetserver

#LIBS REQUIRE
puppet module install puppetlabs-stdlib

