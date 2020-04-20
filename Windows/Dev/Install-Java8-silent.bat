@echo off

if exist "C:\Java\x64\jdk1.8.0\bin\java.exe" goto end

\\nas\Software\Utils\AutoInstall\exe\java8.exe /s INSTALLDIR=C:\Java\x64\jdk1.8.0 /INSTALLDIRPUBJRE=C:\Java\x64\jre1.8.0
setx JAVA_HOME "C:\Java\x64\jdk1.8.0"

:end