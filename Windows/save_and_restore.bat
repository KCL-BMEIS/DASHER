
@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims==" %%A in (..\xnat.cfg) do (
	if "%%A" == "storage_path" (set "storage_path=%%B")
	if "%%A" == "import_data_folder" (set "import_data_folder=%%B")
    
)



rem INSTRUCTIONS:
rem Setup a PC with public access following the instructions in the wiki. 
rem Fill int he xnat.cfg file, but ensure you use the IP address of the intended host.
rem After runing ./build.sh use this script:
rem    save_and_restore.bat save
rem This will create a backup directroy. 
rem Copy he backup to ./uploader/ folder of the new computer and run:
rem    save_and_restore.bat restore
rem REQUIRES LATEST WINDOWS 10 VERSION WITH TAR BUILT IN



set restore=%1


if "%restore%"=="restore" (
     
	echo Restoring images and storage from ./backup
	if not exist ".\backup" (
        echo There is no backup subfolder in the crrent directory.
        GOTO END
	)
	
	docker stack rm secure-dicom-uploader
	rmdir /s /q "%storage_path%"
	echo copying files
	copy .\backup\xnat.cfg .\
	copy .\backup\docker-compose.yml .\
	cd backup
	echo loading docker images
	docker load --input nginx-xnat1.tar
	docker load --input postgres-xnat.tar
	docker load --input xnat1.tar
	docker load --input xnat2.tar
	
    rem docker image import nginx-xnat1.tar  nginx-xnat1:latest
    rem docker image import postgres-xnat.tar postgres-xnat:latest
    rem docker image import xnat1.tar xnat1:latest
    rem docker image import xnat2.tar xnat2:latest
    cd..
	echo extracting storage
    rmdir /s /q "%storage_path%"
    mkdir "%storage_path%"
    tar -C "%storage_path%" -xzf  .\backup\storage_path.tar.gz
	mkdir "%import_data_folder%"

	docker stack deploy -c docker-compose.yml secure-dicom-uploader
	
	GOTO END
    
)


if "%restore%"=="save" (

	echo Saving images and storage to ./backup
	docker stack rm secure-dicom-uploader
	rmdir /s /q backup
	mkdir backup
	echo copying files
	copy ..\xnat.cfg .\backup\xnat.cfg
	copy ..\docker-compose.yml .\backup\docker-compose.yml
	cd backup
	echo backing up docker images
	docker image save  nginx-xnat1 > nginx-xnat1.tar
	docker image save postgres-xnat > postgres-xnat.tar
    docker image save xnat1 > xnat1.tar 
    docker image save xnat2 > xnat2.tar
    cd..
    tar -zcvf .\backup\storage_path.tar.gz -C "%storage_path%" .
	
	GOTO END

)
 
echo "missing paramter 'save' or 'restore'"

:END

