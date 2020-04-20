# AD-OrganizationalUnit management

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

New-ADOrganizationalUnit
New-ADOrganizationalUnit -Name "Fake" -Path "ou=custom,dc=fake,dc=com" -ProtectedFromAccidentalDeletion $true
Set-ADOrganizationalUnit
Remove-ADOrganizationalUnit
Get-ADOrganizationalUnit

exit 0