#!/usr/bin/env bash
LINE=$(docker ps | egrep xnat-web2 | cut -c1-12)
echo "$LINE"
#docker exec -it "$LINE" /bin/bash  
local_project=$1
remote_url=$2
remote_user=$3
remote_pwd=$4

docker exec -it "$LINE" /bin/bash  /data/xnat/setup-xsync-proxy.sh "$local_project" "$remote_url" "$remote_user" "$remote_pwd" > /data/xnat/scripts/logs/xsync_setup.log
