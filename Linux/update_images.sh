#!/usr/bin/env bash

#Check dockerhib for suitable tag
#https://hub.docker.com/_/nginx?tab=tags&page=1
PG_VERSION="postgres:9.5-alpine"
NGINX_VERSION="nginx:stable-alpine"

linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
install_dir=$(pwd)

echo "#######Pulling new docker images..."
docker pull "$PG_VERSION"
docker pull "$NGINX_VERSION"

echo "#########Building new docker images..."
cd postgres

sed -i  "s\FROM postgres:.*\FROM $PG_VERSION \g"   Dockerfile
docker build -t postgres-xnat .
cd ../nginx
sed -i  "s\FROM nginx:.*\FROM $NGINX_VERSION \g"   dockerfile
docker build -t nginx-xnat1 .

cd ../Linux

./restart.sh

echo "#########Restarting and updating XNAT container..."
sleep 200

XNAT1=$(docker ps | egrep xnat-web1 | cut -c1-12)
docker exec  "$XNAT1"   apt-get -y update
docker exec  "$XNAT1"   apt-get -y upgrade

XNAT2=$(docker ps | egrep xnat-web2 | cut -c1-12)
docker exec  "$XNAT2"   apt-get -y update
docker exec  "$XNAT2"   apt-get -y upgrade

docker exec  "$XNAT1" /bin/bash -c  "(crontab -l ; echo \"0 4 * * * apt-get -y update\")| crontab -"
docker exec  "$XNAT1" /bin/bash -c  "(crontab -l ; echo \"30 4 * * * apt-get -y upgrade\")| crontab -"
docker exec  "$XNAT2" /bin/bash -c  "(crontab -l ; echo \"0 4 * * * apt-get -y update\")| crontab -"
docker exec  "$XNAT2" /bin/bash -c  "(crontab -l ; echo \"30 4 * * * apt-get -y upgrade\")| crontab -"
