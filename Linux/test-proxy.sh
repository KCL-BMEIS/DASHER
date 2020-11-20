#!/usr/bin/env bash

linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
cp $uploader_dir/tests/xnat_test_linux_proxy.cfg $uploader_dir/xnat.cfg
cd $uploader_dir
source $uploader_dir/xnat.cfg
docker stack rm secure-dicom-uploader
rm -r $import_data_folder
rm -r $storage_path
cd xnat
tar -cf scripts.tar scripts
cd ..
rm docker-compose.yml
cp /docker/xnat.cfg ./
echo "Stop now to just clean"
cp $uploader_dir/tests/xnat_test_linux_proxy.cfg $uploader_dir/xnat.cfg
sleep 30
cd Linux
./build.sh 



