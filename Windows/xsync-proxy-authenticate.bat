 @setlocal enableextensions enabledelayedexpansion
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web2"') do (
	SET line=%%a
)
SET xnat2=%line:~0,12%
ECHO %xnat2%

setlocal disableDelayedExpansion
set local_project=%1
set remote_url=%2
set remote_user=%3
set remote_pwd=%4

docker exec -it %xnat2% /bin/bash  /data/xnat/setup-xsync-proxy.sh %local_project% %remote_url% %remote_user% %remote_pwd% ^> /data/xnat/scripts/logs/xsync_setup_%local_project%.log
