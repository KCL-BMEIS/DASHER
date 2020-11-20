@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web1"') do (
	
	SET line=%%a
    
)
SET cont=%line:~0,12%
ECHO %cont%
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web2"') do (
	
	SET line=%%a
    
)
SET xnat2=%line:~0,12%
ECHO %xnat2%


set command=%1
if "%command%"=="bash" goto bash
if "%command%"=="bash2" goto bash2
if "%command%"=="delete_test_data" goto delete
 

docker exec -it %cont% /bin/bash  /data/xnat/upload-resources.sh
goto commonexit



:bash
docker exec -it %cont% /bin/bash
goto commonexit

:bash2
docker exec -it %xnat2% /bin/bash
goto commonexit


:delete 
docker exec -it %cont% /bin/bash /opt/scripts/delete_test_data.sh
goto commonexit



:commonexit
