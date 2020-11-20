@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web1"') do (
	
	SET line=%%a
    
)
SET xnat1=%line:~0,12%
ECHO %xnat1%
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web2"') do (
	
	SET line=%%a
    
)
SET xnat2=%line:~0,12%
ECHO %xnat2%


set command=%1
if "%command%"=="1" goto bash
if "%command%"=="2" goto bash2




:bash
docker exec -it %xnat1% /bin/bash
goto commonexit

:bash2
docker exec -it %xnat2% /bin/bash
goto commonexit


:commonexit
