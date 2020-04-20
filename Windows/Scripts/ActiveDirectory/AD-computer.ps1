# AD-Computer management

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

New-ADComputer
New-ADComputer -Name "PC01" -Path "ou=custom,dc=fake,dc=com" -Enabled $true
Set-ADComputer
Remove-ADComputer
Test-ComputerSecureChannel -Repair
Reset-ComputerManchinePassword

exit 0
