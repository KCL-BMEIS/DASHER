@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims==" %%A in (..\xnat.cfg) do (
	if "%%A" == "storage_path" (set "storage_path=%%B")

)

docker stack rm secure-dicom-uploader
@echo off
echo Do NOT press any button. Uploader shutting down. Please wait....
timeout 30 > nul
cd ..

xcopy  .\plugins1  %storage_path%\scripts1\plugins1 /E
xcopy  .\plugins2  %storage_path%\scripts2\plugins2 /E
docker stack deploy -c docker-compose.yml secure-dicom-uploader
cd Windows
rem "####Be patient. Restarting Docker on Windows takes > 30 minutes to restore the databases and to start tomcat ###" 