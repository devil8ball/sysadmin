# Show a popup on target client if device has not been rebooted recently
# This script is intended to use as scheduled task or GPO
# © 2020 Leonardo Ziviani all rights reserved

# Maximun "allowed" day before reboot
$MAX_DAYS = 3

# Alert messages
$MESSAGE_IT = "Il tuo PC non viene spento da più di $MAX_DAYS giorni, ti preghiamo di riavviare la macchina in pausa pranzo o a fine giornata, grazie!"
$MESSAGE_EN = "Your PC is running for more than $MAX_DAYS days, please reboot you machine during breacklunch or at the end of the day, thanks!"

# Get number of days of last boot
$BOOTDATE = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime
$DAY = $BOOTDATE.days

# Launch popup if needed
if($DAY -gt $MAX_DAYS) {
  [System.Windows.MessageBox]::Show("$MESSAGE_IT")
}

exit 0
