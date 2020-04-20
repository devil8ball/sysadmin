# AD-Account management

# @ Version 1.0
# © 2018 Leonardo Ziviani all right reserved

Get-ADSyncScheduler 								# Review the synchronization settings.
Set-ADSyncScheduler –CustomizedSyncCycleInterval 	# Set the synchronization interval
Start-ADSyncSyncCycle –PolicyType Delta 			# Start synchronization manually.
Start-ADSyncSyncCycle 								# Force sync

exit 0
