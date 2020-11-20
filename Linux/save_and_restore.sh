#!/usr/bin/env bash
linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
source $uploader_dir/xnat.cfg

#in order to save images and files, then restore on another ocmputer.
# in xnat.cfg, use the ip address of the intended PC

#INSTRUCTIONS:
#Setup a PC with public access follwoing the instrucitons int he wiki. 
# Fill int he xnat.cfg file, but ensure you use the IP address of the intended host.
#After runing ./build.sh use this script:
#    ./save_and_restore.sh save
#This will create a backup directroy. 
# Copy he backup to ./uploader/ folder of the new computer and run:
#    ./save_and_restore.sh restore

## In order to work with Linux, the postgresql fodler cannot be mounted - before starting you must edit spome files:

# docker-compose-template:
#         line 27, 71 - remove #WIN#, so /pg_backup will be mounted:
#              ./volume/postgres-data1:/pg_backup
#              ./volume/postgres-data2:/pg_backup
#         delete lines 95,50:
#              LINX- ./volume/postgres-data1:/var/lib/postgresql/data
#              LINX- ./volume/postgres-data2:/var/lib/postgresql/data
# ./xnat/templates/cronjoobs.txt:
#        delete #WIN# - this way, the postgresql will backup to the new mounted folder




restore=$1


if [ "$restore" = "restore" ]
then
	echo "Restoring images and storage from ./backup"
	if [ ! -d "./backup" ]
    then
        echo "There is no backup subfolder in the crrent directory."
        exit 1
	fi
	docker stack rm secure-dicom-uploader
	cp ./backup/xnat.cfg ./
	cp ./backup/docker-compose.yml ./
	cd backup
    docker load -i nginx-xnat1.tar.gz
    docker load -i postgres-xnat.tar.gz
    docker load -i xnat1.tar.gz
    docker load -i xnat2.tar.gz
    cd ..
    rm -rf $storage_path
    mkdir $storage_path
    tar -C $storage_path -xzf  ./backup/storage_path.tar.gz
	mkdir -p $import_data_folder

	docker stack deploy -c docker-compose.yml secure-dicom-uploader
    



elif [[ "$restore" = "save" ]]; then
	#statements
	echo "Saving images and storage to ./backup"
	docker stack rm secure-dicom-uploader
	rm -rf backup
	mkdir backup
	cp xnat.cfg ./backup
	cp docker-compose.yml ./backup
	cd backup
	docker image save  nginx-xnat1 > nginx-xnat1.tar
	gzip nginx-xnat1.tar
	docker image save postgres-xnat > postgres-xnat.tar
	gzip postgres-xnat.tar
    docker image save xnat1 > xnat1.tar 
    gzip xnat1.tar 
    docker image save xnat2 > xnat2.tar
    gzip xnat2.tar 
    cd ..
    tar -zcvf ./backup/storage_path.tar.gz -C $storage_path .

else
    echo "missing paramter 'save' or 'restore'"

fi
cd Linux