docker stack rm secure-dicom-uploader
timeout 30
cd..
@setlocal enableextensions enabledelayedexpansion
for /f "tokens=1,2 delims==" %%A in (xnat.cfg) do (
	if "%%A" == "storage_path" (set "storage_path=%%B")
	if "%%A" == "import_data_folder" (set "import_data_folder=%%B")
    
)
rmdir /s /q "%storage_path%"
rmdir /s /q "%import_data_folder%"
rmdir /s /q  xnat_proxy
endlocal

cd Windows
timeout 30
build.bat
