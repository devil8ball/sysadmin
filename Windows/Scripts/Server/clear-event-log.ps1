# Full clear Windows event log
# © 2020 Leonardo Ziviani all rights reserved

Get-EventLog -LogName * | ForEach { Clear-EventLog $_.Log } 

exit 0
