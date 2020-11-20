REM icacls - need to share volume with docker
SET mypath=%~dp0
echo %mypath:~0,-1%
cd %mypath:~0,-1%
REM xxx is test paraemter.... can be anything
Powershell.exe -executionpolicy remotesigned -File build.ps1 ..\xnat.cfg xxx
