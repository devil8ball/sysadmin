@echo off

if exist "C:\Eclipse\Mars\eclipse\eclipse.exe" goto end

if not exist "C:\Eclipse" mkdir C:\Eclipse
if not exist "C:\Eclipse\Mars" mkdir C:\Eclipse\Mars

"C:\Program Files\7-Zip\7z.exe" x \\nas\Software\Utils\AutoInstall\files\mars.zip -oC:\Eclipse\Mars -y

cscript /nologo \\nas\Software\Utils\AutoInstall\script\Create-Shortcut.vbs "%USERPROFILE%\Desktop\Eclipse-Mars.lnk" "C:\Eclipse\Mars\eclipse\eclipse.exe"
echo "-Djava.net.preferIPv4Stack=true" >> C:\Eclipse\Mars\eclipse\eclipse.ini

:end