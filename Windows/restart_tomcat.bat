
@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims==" %%A in (..\xnat.cfg) do (
	if "%%A" == "storage_path" (set "storage_path=%%B")

)


for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web1"') do (
	SET line=%%a    
)
SET xnat1=%line:~0,12%
ECHO %xnat1%

 @setlocal enableextensions enabledelayedexpansion
for /f "tokens=1 delims=" %%a in ('docker ps ^| FINDSTR "xnat-web2"') do (
	SET line=%%a    
)
SET xnat2=%line:~0,12%
ECHO %xnat2%


docker exec -it %xnat1%  su - xnat -c "/opt/tomcat7/bin/shutdown.sh"
docker exec -it %xnat2%  su - xnat -c "/opt/tomcat7/bin/shutdown.sh"

@echo off
echo Do NOT press any button. Tomcat shutting down. Please wait....
timeout 60 > nul

cd ..
xcopy  .\plugins1  %storage_path%\scripts1\plugins1 /E
xcopy  .\plugins2  %storage_path%\scripts2\plugins2 /E
cd Windows

docker exec -it %xnat1%  bash -c "mv /data/xnat/scripts/plugins1/*.jar /data/xnat/home/plugins/"
docker exec -it %xnat1%  chown -R xnat:xnat /data
docker exec -it %xnat1%  chmod -R 775 /data/xnat/home/plugins/

docker exec -it %xnat2%  bash -c "mv /data/xnat/scripts/plugins2/*.jar /data/xnat/home/plugins/"
docker exec -it %xnat2%  chown -R xnat:xnat /data
docker exec -it %xnat2%  chmod -R 775 /data/xnat/home/plugins/

docker exec -it %xnat1%  su - xnat -c "/opt/tomcat7/bin/startup.sh"
docker exec -it %xnat2%  su - xnat -c "/opt/tomcat7/bin/startup.sh"

