# Fully disable SMB1 on windows 8/2012+ server
# A reboot may be required
# © 2020 Leonardo Ziviani all rights reserved

Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

exit 0
