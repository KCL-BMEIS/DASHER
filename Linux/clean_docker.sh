#!/usr/bin/env bash
linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
cd $uploader_dir
source $uploader_dir/xnat.cfg


docker stack rm secure-dicom-uploader
sleep 100

docker system prune
docker images purge

docker rm $(docker ps -qa --no-trunc --filter "status=exited")
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)

#delet
test=$1
if [ "$test" != "test" ]
then
    rm -rf $storage_path
    rm -rf $import_data_folder
fi
cd Linux
