# Registry key location
$REG = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$KEY = "Virtualization"
$DWORD = "MinVmVersionForCpuBasedMitigations"

# Create key
New-Item -Path "$REG" -Name "$KEY"
New-ItemProperty -Path "$REG\$KEY" -Name "$DWORD" -Value '1.0' -PropertyType STRING

exit 0
