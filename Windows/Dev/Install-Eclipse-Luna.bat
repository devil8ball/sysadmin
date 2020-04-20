@echo off

if exist "C:\Eclipse\Luna\eclipse\eclipse.exe" goto end

if not exist "C:\Eclipse" mkdir C:\Eclipse
if not exist "C:\Eclipse\Luna" mkdir C:\Eclipse\Luna

"C:\Program Files\7-Zip\7z.exe" x \\nas\Software\Utils\AutoInstall\files\luna.zip -oC:\Eclipse\Luna -y

cscript /nologo \\nas\Software\Utils\AutoInstall\script\Create-Shortcut.vbs "%USERPROFILE%\Desktop\Eclipse-Luna.lnk" "C:\Eclipse\Luna\eclipse\eclipse.exe"
echo "-Djava.net.preferIPv4Stack=true" >> C:\Eclipse\Luna\eclipse\eclipse.ini

:end