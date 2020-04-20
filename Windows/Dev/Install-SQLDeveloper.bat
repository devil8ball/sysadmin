@echo off

if exist "C:\sqldeveloper\sqldeveloper.exe" goto end

if not exist "C:\sqldeveloper" mkdir C:\sqldeveloper

"C:\Program Files\7-Zip\7z.exe" x \\nas\Software\Utils\AutoInstall\files\sqldeveloper.zip -oC:\sqldeveloper -y
:end