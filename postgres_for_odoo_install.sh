#!/bin/bash
################################################################################
# Script for Installation: OpenERP 7.0 server on Ubuntu 12.04 LTS
# Author: André Schenkels, ICTSTUDIO 2013
#-------------------------------------------------------------------------------
#  
# This script will install OpenERP Server with PostgreSQL server 9.2 on
# clean Ubuntu 12.04 Server
#-------------------------------------------------------------------------------
# USAGE:
#
# oe-install
#
# EXAMPLE:
# oe-install 
#
################################################################################
 
##fixed parameters
#openerp
OE_USER="openerp"
OE_HOME="/opt/openerp"

#Enter version for checkout "/6.1" for version 6.1, "/7.0" for version 7.0 and "" for trunk
OE_VERSION="/7.0"

#set the superadmin password
OE_SUPERADMIN="superadminpasswordmyodoo"
OE_CONFIG="openerp-server"

#choose postgresql version [8.4, 9.1, 9.2 or 9.3]
PG_VERSION="9.2"

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
echo -e "\n---- Install PostgreSQL Server $PG_VERSION  ----"
sudo wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo su root -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' >> /etc/apt/sources.list.d/pgdg.list"
sudo su root -c "echo 'Package: *' >> /etc/apt/preferences.d/pgdg.pref"
sudo su root -c "echo 'Pin: release o=apt.postgresql.org' >> /etc/apt/preferences.d/pgdg.pref"
sudo su root -c "echo 'Pin-Priority: 500' >> /etc/apt/preferences.d/pgdg.pref"
yes | sudo apt-get update
yes | sudo apt-get install pgdg-keyring
yes | sudo apt-get install postgresql-$PG_VERSION
	
echo -e "\n---- PostgreSQL $PG_VERSION Settings  ----"
sudo sed -i s/"#listen_addresses = 'localhost'"/"listen_addresses = '*'"/g /etc/postgresql/$PG_VERSION/main/postgresql.conf

echo -e "\n---- Creating the OpenERP PostgreSQL User  ----"
sudo su - postgres -c "createuser -s $OE_USER" 2> /dev/null || true




 
echo "PostgreSQL install done!"

