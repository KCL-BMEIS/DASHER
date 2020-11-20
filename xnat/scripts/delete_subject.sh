#!/bin/bash
source /data/xnat/home/xnat.cfg
url="http://xnat-web2:8080/anon"
project=$1
subject_id=$2
curl_params=" -u $xnat_admin_user:$xnat_admin_pwd "


# GET ASSESSORS
res=$(curl $curl_params -X GET  "http://localhost:8080/data/projects/$project/subjects/$subject_id/experiments?xsiType=clinicalTrials:clinicaltrial" |
jq -r '.ResultSet.Result')
echo "$res"

for row in $(echo "${res}" | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

  label=$(_jq '.label' )
   idd=$(_jq '.ID')
  label2=$(echo $idd| cut -d'_' -f 1)
   #=$(echo $id| cut -d'_' -f 3)
    #echo "$label    $idd   $label2"
   ### delete anonymised sessions
    curl $curl_params -X DELETE  "$url/data/projects/$project/experiments/$label2"
    curl $curl_params -X DELETE  "$url/data/projects/$project/experiments/$label2"
#    echo "curl $curl_params -X DELETE  '$url/data/projects/$project_Clinical_Trials/experiments/$id'"#
#	curl $curl_params -X DELETE  "$url/data/projects/$project_Clinical_Trials/experiments/$label"
#    curl $curl_params -X DELETE  "$url/data/projects/$project_Research/experiments/$label"
done

curl $curl_params -X DELETE  "http://localhost:8080/data/projects/$project/subjects/$subject_id/"

### create subject assessor on anonymised site, set xsync to sync it, a 'delete_subject' assessor, triggering delete on central side


