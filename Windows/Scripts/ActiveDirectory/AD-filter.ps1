# AD query filter example

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

# Show all properties for given account
Get-ADUser -Name "Administrator" -Properties *

# Show all accounts in an OU
Get-ADUser -Filter * -SearchBase "ou=custom,dc=fake,dc=com" -SearchScope subtree

# Show all user with last sign date older than given date
Get-ADUser -Filter {lastlogondate -lt "January 1, 2018"}

# Show all user with last sign date older than given date in given OU
Get-ADUser -Filter {lastlogondate -lt "January 1, 2018"} -and (department -eq "Custom")

exit 0