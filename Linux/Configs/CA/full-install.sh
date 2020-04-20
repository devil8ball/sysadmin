#!/bin/bash

# Full setup of a Linux Certificate Authority
# @ Version 2.0
# © 2018 Leonardo Ziviani all rights reserved

# Text color and style
DEFAULT='\e[0m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'

# Check if is running as root
if [ "$EUID" -ne 0 ]; then
	echo -e "$RED This script must be run as root... $DEFAULT"
	exit -1
fi


#
# Start of config parameters
#

# Name and domain
HOSTNAME="ca"							# Machine hostname
DOMAIN="fake.com"						# Organization domain

# Paths
BASE="/root/ca"							# Base path for install
FTP="/var/ftp/ca"						# Web public folder

# Network
IP="192.168.0.111"						# Static ip to set
MASK="255.255.255.0"					# Network mask
GATEWAY="192.168.0.1"					# Network gateway

# OpenSSL settings
ORGANIZATION="Snake Oil L.L.C."			# Organization name
MAIL="system@fake.com"					# support email
COUNTRY="IT"							# Two letter country code
STATE="Italy"							# State
ORGUNIT="IT"							# Organization Unit

# Certificate settings
PWD="47_nK!maYfAuh$G4EmyxK_Q4MR@Pjn^L"	# Private key password
CIPHER="-aes256"                		# Default cipher
ENCRYPT="-SHA512"						# Default encrypt method
KEY="CA.key"                     		# ROOT CA key name
CA="CA.pem"                     		# ROOT CA name
BYTE="4096"                     		# Key length
DAYS="3650"             				# Validity day
OUT="$BASE/private"             		# Output folder

#
# End of config parameters
#


# Derivate config parameters (DO NOT EDIT!)
DOMAIN_UP="${echo $DOMAIN | tr /a-z/ /A-Z/}"
DOMAIN_PRE="${echo $DOMAIN | cut -f1 -d '.'}"
DOMAIN_POST="${echo $DOMAIN | cut -f2 -d '.'}"
DOMAIN_PRE_UP="${echo $DOMAIN_UP | cut -f1 -d '.'}"
DOMAIN_PRE_POST="${echo $DOMAIN_UP | cut -f2 -d '.'}"
CRL="$HOSTNAME.$DOMAIN"
PWD_PATH="-passout file:$BASE/private/password"

# Substitution settings (DO NOT EDIT!)
CONFIG_DOMAIN_PRE="fake"
CONFIG_DOMAIN_PRE_UP="FAKE"
CONFIG_DOMAIN_POST="com"
CONFIG_DOMAIN_POST_UP="COM"
CONFIG_DOMAIN="fake.com"
CONFIG_DOMAIN_UP="FAKE.COM"
CONFIG_ORGANIZATION="Snake Oil L.L.C."
CONFIG_MAIL="system@fake.com"
CONFIG_COUNTRY="XX"
CONFIG_STATE="fakeland"
CONFIG_CITY="fakecity"
CONFIG_ORGUNIT="DepartmentXX"
CONFIG_FQDN="ca.fake.com"

# Install needed packages
echo "Install needed packages..."
apt-get -y -o Dpkg::Options::="--force-confnew" openssl ntp sssd dnsutils net-tools krb5-user realmd vsftpd ssmtp mailutils

# Create base dirs
echo "Configure new dirs..."
mkdir $BASE
mkdir $FTP
mkdir $FTP/ca
mkdir $FTP/csr
mkdir $BASE/crl
mkdir $BASE/private
mkdir $BASE/requests
mkdir $BASE/certs
mkdir $BASE/private
mkdir -p /scripts/ca
touch $BASE/crlnumber
touch $BASE/index
touch $BASE/index.attr
ln -s /usr/lib/ssl/openssl.conf $BASE/conf/openssl.conf
echo 1000 > $BASE/serial
echo $PWD > $BASE/private/password
chown -R root:root $BASE
chmod -R 700 $BASE
chown -R nobody:nogroup $FTP
chmod -R 750 $FTP
chown -R root:root /scripts
chmod -R 700 /scripts
echo "" >> /root/.bashrc
echo "# Paths" >> /root/.bashrc
echo "export PATH=\$PATH:/scripts" >> /root/.bashrc
echo "export PATH=\$PATH:/scripts/ca" >> /root/.bashrc

# Overwrite configs
echo "Copy configs..."
cp -r ntp.conf /etc/
cp -r vsftpd.conf /etc/
cp -r realmd.conf /etc/
cp -r openssl.conf /usr/lib/ssl/
cp -r sssd.conf /etc/sssd/
chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf
cp -r 001-ca.conf /etc/apache2/sites-available
a2ensite 001-ca.conf

# Final config setup
echo "Fine tune configs..."
sed -i "s/$CONFIG_DOMAIN_PRE_UP/$DOMAIN_PRE_UP/g" /etc/realmd.conf
sed -i "s/$CONFIG_DOMAIN/$DOMAIN/g" /etc/sssd/sssd.conf
sed -i "s/$FQDN/$CRL/g" /etc/sssd/sssd.conf
sed -i "s/$FQDN/$CRL/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_ORGANIZATION/$ORGANIZATION/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_MAIL/$MAIL/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_COUNTRY/$COUNTRY/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_STATE/$STATE/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_CITY/$CITY/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_ORGUNIT/$ORGUINIT/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_FQDN/$CRL/g" /usr/lib/ssl/openssl.conf
sed -i "s/$CONFIG_MAIL/$MAIL/g" /etc/apache2/sites-available/001-ca.conf
sed -i "s/$CONFIG_FQDN/$CRL/g" /etc/apache2/sites-available/001-ca.conf

# Create ROOT CA private key
echo "Generate private key..."
openssl genrsa $PWD $CIPHER -out $BASE/private/$CA $BYTE
chmod 400 $OUT/*.key

# Create ROOT CA
echo "Generate root ca..."
openssl req -new -x509 $ENCRYPT -key $BASE/private/$KEY $PWD -out $BASE/certs/$CA -days $DAY -set_serial 0
cp $BASE/certs/$CA $FTP

echo "Server will reboot in 1 minutes..."
shutdown -r -t 1

exit 0
