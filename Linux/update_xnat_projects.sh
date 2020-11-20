#!/usr/bin/env bash
LINE=$(docker ps | egrep xnat-web1 | cut -c1-12)
echo "$LINE"
#docker exec -it "$LINE" /bin/bash  

bsh=$1
cntainer=$2
if [ "$bsh" == "bash" ]
then
	if [ "$cntainer" == "2" ]
	then
		LINE=$(docker ps | egrep xnat-web2 | cut -c1-12)
	fi
	docker exec -it "$LINE" /bin/bash  
else
	docker exec -it "$LINE" /bin/bash  /data/xnat/upload-resources.sh
fi