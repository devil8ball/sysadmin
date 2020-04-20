# AD-Account management

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

New-ADUser
New-ADUser "Ubaldo Sterchi" -AccountPassword (Read-Host -AsSecureString "Password: ") -Department "Fake"
Set-ADUser
Remove-ADUser
Set-ADAccountPassword
Set-ADAccountExpiration
Unlock-ADAccount
Enable-ADAccount
Disable-ADAccount

exit 0
