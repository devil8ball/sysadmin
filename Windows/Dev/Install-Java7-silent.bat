@echo off

if exist "C:\Java\x64\jdk1.7.0\bin\java.exe" goto end

\\nas\Software\Utils\AutoInstall\exe\java7.exe /s INSTALLDIR=C:\Java\x64\jdk1.7.0 /INSTALLDIRPUBJRE=C:\Java\x64\jre1.7.0
setx JAVA_HOME "C:\Java\x64\jdk1.7.0"

:end