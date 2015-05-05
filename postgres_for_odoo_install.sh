#!/bin/bash
################################################################################
# Script for Installation: PostgreSQL 9.2 on Ubuntu 12.04 LTS
# Original author: André Schenkels, ICTSTUDIO 2013
#-------------------------------------------------------------------------------
# Modified by Sicambria
# https://github.com/sicambria/
#-------------------------------------------------------------------------------
# This script will install PostgreSQL server 9.2 on a clean Ubuntu 12.04 Server
#-------------------------------------------------------------------------------
# USAGE:
# wget https://raw.githubusercontent.com/sicambria/odoo-install-sh/master/postgres_for_odoo_install.sh
# sudo sh postgres_for_odoo_install.sh
#
################################################################################
 
# OpenERP/Odoo username
OE_USER="openerp"

#choose PostgreSQL version [8.4, 9.1, 9.2 or 9.3]
PG_VERSION="9.2"

# PostgreSQL IP address
ODOO_VM_IP_ADDRESS="127.0.0.1"

# Set the PostgreSQL password for OE_USER
DBMS_PASSWORD="ChangeFromDefaultpasswdToComplexPassword"

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

# Alter password for previously created user:
sudo -u postgres psql -c "alter user $OE_USER password $DBMS_PASSWORD;"

# Allow access from the specified IP address
sudo echo "host all all $ODOO_VM_IP_ADDRESS/32 md5" >> /etc/postgresql/$PG_VERSION/main/pg_hba.conf

# RESTART PostgreSQL
sudo service postgresql restart 
 
echo "PostgreSQL install done!"

