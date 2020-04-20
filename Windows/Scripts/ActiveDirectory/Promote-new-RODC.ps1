# Promote server to RODC of given domain

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

Install-ADDSDomainController -Credential (Get-Credential) -DomainName $domain -InstallDNS:$true -ReadOnlyReplica:$true -Force:$true

exit 0
