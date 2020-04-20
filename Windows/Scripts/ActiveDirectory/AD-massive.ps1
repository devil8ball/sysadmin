# AD CSV file evaluation (see account.csv)

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

# Get user from .csv file
$users=Import-CSV -LiteralPath "accounts.csv"

# Loop each user
foreach ($user in $users) {
	New-ADUser "$user.FirstName $user.LastName" -AccountPassword "$user.Password" -Department "$user.Department" -Enabled $true
}

exit 0