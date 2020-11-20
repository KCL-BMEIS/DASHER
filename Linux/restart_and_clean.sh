#!/usr/bin/env bash
linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
source $uploader_dir/xnat.cfg
docker stack rm secure-dicom-uploader


if [ -d "$import_data_folder" ]
then
     rm -r $import_data_folder
fi

if [ -d "$storage_path" ]
then
     rm -r $storage_path
fi

if [ -d "./xnat_proxy" ]
then
     rm -r ./xnat_proxy
fi

sleep 30
cd Linux
./build.sh

