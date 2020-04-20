$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
$Name = "VisualFXSetting"
$value = "2"

New-ItemProperty -Path $reg -Name $name -Value $value -PropertyType DWORD -Force | Out-Null