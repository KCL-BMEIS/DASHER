#!/usr/bin/env bash
linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
if [ ! -f "$uploader_dir/xnat.cfg" ]
then
        echo "Error: Cannot find xnat.cfg file"
        exit 1
fi

dos2unix $uploader_dir/xnat.cfg
source $uploader_dir/xnat.cfg


docker stack rm secure-dicom-uploader
echo "Shutting down Uploader Stack. Please wait."
cp -r $uploader_dir/plugins1  $storage_path/scripts1/
cp -r $uploader_dir/plugins2  $storage_path/scripts2/
sleep 30
docker stack deploy -c $uploader_dir/docker-compose.yml secure-dicom-uploader



