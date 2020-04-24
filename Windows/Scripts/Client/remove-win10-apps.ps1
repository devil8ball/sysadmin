# Remove all uneeded apps of Windows 10 (and disable app installation for new users)
# Run with admin rights
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

Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.WindowsFeedbackHub"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.BingWeather"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Office.OneNote"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.ZuneVideo"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.xboxapp"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.ZuneMusic"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Xbox.TCUI"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.XboxGameOverlay"}  | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Microsoft3DViewer"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Messaging"}   | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.MixedReality.Portal"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.XboxGamingOverlay"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Print3D"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Microsoft.WindowsMaps"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.WindowsSoundRecorder"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.MicrosoftOfficeHub"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.WindowsAlarms"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.People"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.XboxSpeechToTextOverlay"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.SkypeApp"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.YourPhone"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.XboxIdentityProvider"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.Wallet"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.MicrosoftStickyNotes"} | Remove-AppxProvisionedPackage
Get-appxprovisionedpackage -online | where-object {$_.PackageName -like "Microsoft.OneConnect"} | Remove-AppxProvisionedPackage -online





exit 0
