@echo off

if exist "C:\Java\x64\jdk1.5.0\bin\java.exe" goto end

\\nas\Software\Utils\AutoInstall\exe\java5.exe /s INSTALLDIR=C:\Java\x64\jdk1.5.0 /INSTALLDIRPUBJRE=C:\Java\x64\jre1.5.0
setx JAVA_HOME "C:\Java\x64\jdk1.5.0"

:end