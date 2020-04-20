# AD-Groups management

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

New-ADGroup
New-ADGroup -Name "Fake" -Path "ou=custom,dc=fake,dc=com" -GroupScope Global -GroupCategory Security
Set-ADGroup
Remove-ADGroup
Add-ADGroupMember
Add-ADGroupMember -Name "Fake" -Members "Ubaldo"
Get-ADGroupMember
Remove-ADGroupMember
Add-ADPrincipalGroupMembership
Get-ADPrincipalGroupMembership
Remove-ADPrincipalGroupMembership

exit 0
