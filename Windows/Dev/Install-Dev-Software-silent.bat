@echo off

rem if exist "C:\Program Files (x86)\WinSCP\WinSCP.exe" goto scp
\\nas\Software\Utils\AutoInstall\exe\soapui.exe -q

:scp
if exist "C:\Program Files (x86)\WinSCP\WinSCP.exe" goto vpn
\\nas\Software\Utils\AutoInstall\exe\winscp.exe /VERYSILENT 

:vpn
if exist "C:\Program Files\OpenVPN\bin\openvpn-gui.exe" goto adobe
\\nas\Software\Utils\AutoInstall\exe\openvpn.exe /S /SELECT_SHORTCUTS=1 /SELECT_OPENVPN=1 /SELECT_SERVICE=1 /SELECT_TAP=1 /SELECT_OPENVPNGUI=1 /SELECT_ASSOCIATIONS=1 /SELECT_OPENSSL_UTILITIES=1 /SELECT_EASYRSA=1 /SELECT_PATH=1 /SELECT_OPENSSLDLLS=1 /SELECT_LZODLLS=1 /SELECT_PKCS11DLLS=1

:adobe
if exist "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" goto git
\\nas\Software\Utils\AutoInstall\exe\adobe.exe /sALL

:git
if exist "C:\Program Files\Git\git-bash.exe" goto end
\\nas\Software\Utils\AutoInstall\exe\git.exe /VERYSILENT

:end