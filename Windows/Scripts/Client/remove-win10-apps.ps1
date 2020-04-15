# Remove all uneeded apps of Windows 10 (and disable app installation for new users)
# © 2020 Leonardo Ziviani all rights reserved

Get-AppxPackage -allusers Microsoft.WindowsFeedbackHub | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Office.OneNote | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.ZuneVideo | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.xboxapp | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Xbox.TCUI | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.XboxGameOverlay  | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Messaging   | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.MixedReality.Portal | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Print3D | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Microsoft.WindowsMaps | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.WindowsSoundRecorder | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.WindowsAlarms | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.People | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.Wallet | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.MicrosoftStickyNotes | Remove-AppxPackage
Get-AppxPackage -allusers Microsoft.OneConnect | Remove-AppxPackage

exit 0
