#!/usr/bin/env bash
#sudo docker exec -it `sudo docker ps -q --filter ancestor=xnat1:latest` /opt/scripts/restart_tomcat.sh
#sudo docker exec -it `sudo docker ps -q --filter ancestor=xnat2:latest` /opt/scripts/restart_tomcat.sh
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


XNAT1=$(docker ps | egrep xnat-web1 | cut -c1-12)
XNAT2=$(docker ps | egrep xnat-web2 | cut -c1-12)
echo "###################################"
echo "Resarting tomcat in containers - Non-anonymised XNAT: $XNAT1   -   Pseudonymised XNAT: $XNAT2"
echo "###################################"
sudo docker exec -it "$XNAT1"  su - xnat -c "/opt/tomcat7/bin/shutdown.sh"
sudo docker exec -it "$XNAT2"  su - xnat -c "/opt/tomcat7/bin/shutdown.sh"

echo "Shutting down Tomcat. Please wait."
sleep 60

cp -r $uploader_dir/plugins1  $storage_path/scripts1/
cp -r $uploader_dir/plugins2  $storage_path/scripts2/

sudo docker exec -it "$XNAT1"  bash -c 'mv /data/xnat/scripts/plugins1/*.jar /data/xnat/home/plugins/'
sudo docker exec -it "$XNAT1"  chown -R xnat:xnat /data
sudo docker exec -it "$XNAT1"  chmod -R 775 /data/xnat/home/plugins/

sudo docker exec -it "$XNAT2"  bash -c 'mv /data/xnat/scripts/plugins2/*.jar /data/xnat/home/plugins/'
sudo docker exec -it "$XNAT2"  chown -R xnat:xnat /data
sudo docker exec -it "$XNAT2"  chmod -R 775 /data/xnat/home/plugins/

sudo docker exec -it "$XNAT1" su - xnat -c "/opt/tomcat7/bin/startup.sh"
sudo docker exec -it "$XNAT2" su - xnat -c "/opt/tomcat7/bin/startup.sh"
