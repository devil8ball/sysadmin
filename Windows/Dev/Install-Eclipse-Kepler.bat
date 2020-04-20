@echo off

if exist "C:\Eclipse\Kepler\eclipse\eclipse.exe" goto end

if not exist "C:\Eclipse" mkdir C:\Eclipse
if not exist "C:\Eclipse\Kepler" mkdir C:\Eclipse\Kepler

"C:\Program Files\7-Zip\7z.exe" x \\nas\Software\Utils\AutoInstall\files\kepler.zip -oC:\Eclipse\Kepler -y

cscript /nologo \\nas\Software\Utils\AutoInstall\script\Create-Shortcut.vbs "%USERPROFILE%\Desktop\Eclipse-Kepler.lnk" "C:\Eclipse\Kepler\eclipse\eclipse.exe"
echo "-Djava.net.preferIPv4Stack=true" >> C:\Eclipse\Kepler\eclipse\eclipse.ini

:end