#!/bin/bash

# Check geographic origin of given ip
# © 2020 Leonardo Ziviani all rights reserved

# Global variables
TMP="/tmp/response";

# Remove temp file
rm -f $TMP

# Arguments check
if [ -z $1 ]; then
  echo "Missing arguments..."
  echo "Use where-ip <ipv4 address>"
  echo "Ex. where-ip 1.1.1.1"
  exit -1
fi

# Check if given ip address is valid
if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	for i in 1 2 3 4; do
		if [ $(echo "$1" | cut -d. -f$i) -gt 254 ]; then
			echo "Malformed ip address..."
			echo "You cannot insert a value greater than 254 in an address.."
			exit -1
		fi
	done
else
	echo "Malformed ip address..."
	echo "Use only ipv4 style ip address"
	echo "Ex. 1.1.1.1"
	exit -1
fi

# Check if given ip address contains a 0 at the end
if [[ $1 == *".0" ]]; then
	echo "Malformed ip address..."
	echo "You cannot insert a network address..."
	exit -1
fi

# Check if given ip address is a local address
[[ $1 == 192.168.* ]]; then
  echo "192.168.x.x is a local private address..."
  echo "Insert a valid public address..."
  exit -1
fi

# Check if given ip address is a local address
[[ $1 == 10.* ]]; then
  echo "10.x.x.x is a local private address..."
  echo "Insert a valid public address..."
  exit -1
fi

echo searching for $1...

# Request to freegeoip.net
curl freegeoip.net/xml/$1 | sed 's/\t//g' > $TMP

clear
CC="$(cat $TMP | grep '<CountryCode>' | sed 's/<CountryCode>//g' | sed 's/<\/CountryCode>//g')"
CN="$(cat $TMP | grep '<CountryName>' | sed 's/<CountryName>//g' | sed 's/<\/CountryName>//g')"
RN="$(cat $TMP | grep '<RegionName>' | sed 's/<RegionName>//g' | sed 's/<\/RegionName>//g')"
CITY="$(cat $TMP | grep '<City>' | sed 's/<City>//g' | sed 's/<\/City>//g')"
ZIP="$(cat $TMP | grep '<ZipCode>' | sed 's/<ZipCode>//g' | sed 's/<\/ZipCode>//g')"
LAT="$(cat $TMP | grep '<Latitude>' | sed 's/<Latitude>//g' | sed 's/<\/Latitude>//g')"
LON="$(cat $TMP | grep '<Longitude>' | sed 's/<Longitude>//g' | sed 's/<\/Longitude>//g')"

# Remove temp file
rm -f $TMP

echo ""
echo "IP $1 located in:"
echo ""
echo "$CN ($CC)"
echo "$RN, $CITY ($ZIP)"
echo "$LAT - $LON"
echo ""

exit 0
