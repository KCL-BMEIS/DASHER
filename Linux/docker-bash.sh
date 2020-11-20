#!/usr/bin/env bash
LINE=$(docker ps | egrep xnat-web1 | cut -c1-12)
echo "$LINE"
#docker exec -it "$LINE" /bin/bash  


cntainer=$1
echo "$cntainer"
if [ "$cntainer" == "2" ]
	then
        echo "container 2"
	LINE=$(docker ps | egrep xnat-web2 | cut -c1-12)
	docker exec -it "$LINE" /bin/bash  
else
        echo "container 1"
	docker exec -it "$LINE" /bin/bash
fi