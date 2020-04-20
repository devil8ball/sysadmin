@echo off

reg delete HKCR\CLSID\{988248f3-a1ad-49bf-9170-676cbbc36ba3} /va /f
netcfg -v -u dni_dne

PAUSE