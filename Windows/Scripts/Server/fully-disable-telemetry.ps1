# Fully disable telemetry on Windows Server 2016
# © 2020 Leonardo Ziviani all rights reserved

# Disable services
Set-Service -name diagtrack -StartupType disabled
Stop-Service -name diagtrack
Set-Service -name dmwappushservice -StartupType disabled
Stop-Service -name dmwappushservice

# Disable scheduled task
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" StartupAppTask | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" ProgramDataUpdater | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Application Experience\" "Microsoft Compatibility Appraiser" | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Autochk\" Proxy | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" Consolidator | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" KernelCeipTask | Disable-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Customer Experience Improvement Program\" UsbCeip | Disable-ScheduledTask

exit 0
