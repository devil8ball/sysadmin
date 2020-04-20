# Promote server to DC of given domain
# Use only first time!

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

# Domain name parameter
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[ValidateNotNullOrEmpty()]
	[string]$domain					
)

# Arguments check
if ($domain -notlike '*.*') {
	echo "Invalid domain..."
	exit -1
}

# Install DC and DNS with given domain
Install-ADDSForest -DomainName $domain -InstallDNS

exit 0