@echo off

call \\nas\Software\Utils\AutoInstall\script\Install-Java7-silent.bat
call \\nas\Software\Utils\AutoInstall\script\Install-Java8-silent.bat
call \\nas\Software\Utils\AutoInstall\script\Install-Eclipse-Kepler.bat
call \\nas\Software\Utils\AutoInstall\script\Install-Eclipse-Luna.bat
call \\nas\Software\Utils\AutoInstall\script\Install-Eclipse-Mars.bat
call \\nas\Software\Utils\AutoInstall\script\Install-SQLDeveloper.bat
call \\nas\Software\Utils\AutoInstall\script\Install-Dev-Software-silent.bat
call \\nas\Software\Utils\AutoInstall\script\firewall.bat