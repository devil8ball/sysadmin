# Windows 2016 hardening
# © 2020 Leonardo Ziviani all rights reserved

REG Add "HKLM\SOFTWARE\Policies\Microsoft\FVE"
REG Add "HKLM\Software\Policies\Microsoft\Windows\PreviewBuilds"
REG Add "HKLM\Software\Policies\Microsoft\Windows\Windows Search"
REG Add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform"
REG Add "HKLM\Software\Policies\Microsoft\Windows Defender\Spynet"
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
REG Add "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
REG Add "HKLM\Software\Policies\Microsoft\Windows\PowerShell\Transcription"
REG Add "HKLM\software\Policies\Microsoft\Camera"
REG Add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures"
REG Add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork"
REG Add "HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager"
REG Add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy"
REG Add "HKLM\Software\Policies\Microsoft\WindowsStore"


$HKEY_LOCAL_MACHINE = 2147483650 
$strComputer = "."
$strPath19 = "SOFTWARE\Policies\Microsoft\FVE"
$strPath20 = "SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$strPath21 = "Software\Policies\Microsoft\Windows\PreviewBuilds"
$strPath22 = "Software\Policies\Microsoft\Windows\Windows Search"
$strPath23 = "Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform"
$strPath24 = "Software\Policies\Microsoft\Windows Defender\Spynet"
$strPath25 = "SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
$strPath26 = "Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$strPath27 = "Software\Policies\Microsoft\Windows\PowerShell\Transcription"
$strPath28 = "software\Policies\Microsoft\Camera"
$strPath29 = "SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$strPath30 = "SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures"
$strPath31 = "SOFTWARE\Policies\Microsoft\PassportForWork"
$strPath32 = "Software\Policies\Microsoft\Windows\CurrentVersion\AppModel\StateManager"
$strPath33 = "Software\Policies\Microsoft\Windows\Appx"
$strPath34 = "Software\Policies\Microsoft\Windows\AppPrivacy"
$strPath35 = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
$strPath36 = "Software\Policies\Microsoft\WindowsStore"

$strDWORDValue41 = "EncryptionMethodWithXtsFdv"
$strDWORDValue42 = "EncryptionMethodWithXtsOs"
$strDWORDValue43 = "EncryptionMethodWithXtsRdv"
$strDWORDValue44 = "AllowTelemetry"
$strDWORDValue45 = "EnableExperimentation"
$strDWORDValue46 = "EnableConfigFlighting"
$strDWORDValue47 = "DoNotShowFeedbackNotifications"
$strDWORDValue48 = "AllowCortana"
$strDWORDValue49 = "AllowSearchToUseLocation"
$strDWORDValue50 = "NoGenTicket"
$strDWORDValue51 = "SubmitSamplesConsent"
$strDWORDValue52 = "AutoApproveOSDumps"
$strDWORDValue53 = "EnableScriptBlockLogging"
$strDWORDValue54 = "EnableTranscripting"
$strDWORDValue55 = "RedirectOnlyDefaultClientPrinter"
$strDWORDValue56 = "EnhancedAntiSpoofing"
$strDWORDValue57 = "Enabled"
$strDWORDValue58 = "AllowSharedLocalAppData"
$strDWORDValue59 = "AllowDevelopmentWithoutDevLicense"
$strDWORDValue60 = "LetAppsAccessAccountInfo"
$strDWORDValue61 = "LetAppsAccessCallHistory"
$strDWORDValue62 = "LetAppsAccessContacts"
$strDWORDValue63 = "LetAppsAccessEmail"
$strDWORDValue64 = "LetAppsAccessLocation"
$strDWORDValue65 = "LetAppsAccessMessaging"
$strDWORDValue66 = "LetAppsAccessMotion"
$strDWORDValue67 = "LetAppsAccessCalendar"
$strDWORDValue68 = "LetAppsAccessCamera"
$strDWORDValue69 = "LetAppsAccessMicrophone"
$strDWORDValue70 = "LetAppsAccessTrustedDevices"
$strDWORDValue71 = "LetAppsAccessRadios"
$strDWORDValue72 = "LetAppsSyncWithDevices"
$strDWORDValue73 = "LetAppsAccessPhone"
$strDWORDValue74 = "BlockHostedAppAccessWinRT"
$strDWORDValue75 = "DisableStoreApps"
$strDWORDValue76 = "AutoDownload"
$strDWORDValue77 = "DisableOSUpgrade"
$strDWORDValue78 = "RemoveWindowsStore"

$uValue = (6)
$uValue1 = (0x0)
$uValue2 = (1)
$uValue3 = (0)
$uValue4 = (2)
$uValue5 = (AllowCamera)

$reg = [wmiclass]"\\$strComputer\root\default:StdRegprov"
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath19, $strDWORDValue41, $uValue) #Windows 2016 - livello crittografia bitlocker#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath19, $strDWORDValue42, $uValue) #Windows 2016 - livello crittografia bitlocker#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath19, $strDWORDValue43, $uValue) #Windows 2016 - livello crittografia bitlocker#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath20, $strDWORDValue44, $uValue1) #Windows 2016 - data collection#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath21, $strDWORDValue45, $uValue2) #Windows 2016 - Microsoft experiment program#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath21, $strDWORDValue46, $uValue2) #Windows 2016 - Microsoft experiment program#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath20, $strDWORDValue47, $uValue3) #Windows 2016 - Feedback Microsoft#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath22, $strDWORDValue48, $uValue3) #Windows 2016 - no Cortana#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath22, $strDWORDValue49, $uValue3) #Windows 2016 - no location#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath23, $strDWORDValue50, $uValue2) #Windows 2016 - activation to Microsoft#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath24, $strDWORDValue51, $uValue4) #Windows 2016 - MAPS telemetry#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath25, $strDWORDValue52, $uValue3) #Windows 2016 - memory dumps#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath26, $strDWORDValue53, $uValue3) #Windows 2016 - PowerShell/Operational event log#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath27, $strDWORDValue54, $uValue3) #Windows 2016 - PowerShell commands into text-based transcripts#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath28, $strDWORDValue44, $uValue5) #Windows 2016 - Camera devices#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath29, $strDWORDValue55, $uValue3) #Windows 2016 - default client printer#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath30, $strDWORDValue56, $uValue2) #Windows 2016 - enhanced anti-spoofing#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath31, $strDWORDValue57, $uValue3) #Windows 2016 - Microsoft Passport for Work#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath32, $strDWORDValue58, $uValue3) #Windows 2016 - share data between users#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath33, $strDWORDValue59, $uValue3) #Windows 2016 - development of Windows Store#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue60, $uValue4) #Windows 2016 - Windows apps can access account information#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue61, $uValue4) #Windows 2016 - Windows apps can access call history#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue62, $uValue4) #Windows 2016 - Windows apps can access access contacts#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue63, $uValue4) #Windows 2016 - Windows apps can access access email#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue64, $uValue4) #Windows 2016 - Windows apps can access access location#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue65, $uValue4) #Windows 2016 - Windows apps can access read or send messages#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue66, $uValue4) #Windows 2016 - Windows apps can access motion data#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue67, $uValue4) #Windows 2016 - Windows apps can access calendar#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue68, $uValue4) #Windows 2016 - Windows apps can access the camera#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue69, $uValue4) #Windows 2016 - Windows apps can access the microphone#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue70, $uValue4) #Windows 2016 - Windows apps can access trusted devices#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue71, $uValue4) #Windows 2016 - Windows apps can access control radios#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue72, $uValue4) #Windows 2016 - Windows apps can access sync with devices#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath34, $strDWORDValue73, $uValue4) #Windows 2016 - Windows apps can make phone calls#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath35, $strDWORDValue74, $uValue2) #Windows 2016 - Windows Runtime API#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath36, $strDWORDValue75, $uValue3) #Windows 2016 - turns off the launch of all apps#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath36, $strDWORDValue76, $uValue4) #Windows 2016 - automatic download and installation of app updates#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath36, $strDWORDValue77, $uValue2) #Windows 2016 - the Store offer to update to the latest version of Windows#
[void]$reg.SetDWORDValue($HKEY_LOCAL_MACHINE, $strPath36, $strDWORDValue78, $uValue2) #Windows 2016 - access to the Store application#
