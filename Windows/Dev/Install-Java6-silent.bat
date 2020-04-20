@echo off

if exist "C:\Java\x64\jdk1.6.0\bin\java.exe" goto end

\\nas\Software\Utils\AutoInstall\exe\java6.exe /s INSTALLDIR=C:\Java\x64\jdk1.6.0 /INSTALLDIRPUBJRE=C:\Java\x64\jre1.6.0
setx JAVA_HOME "C:\Java\x64\jdk1.6.0"

:end