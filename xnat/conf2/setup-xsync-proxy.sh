source /data/xnat/home/xnat.cfg

#proxy
#remote_user="xnat"
#remote_pwd="xnat"
local_project=$1
remote_url=$2
remote_user=$3
remote_pwd=$4

#get token
echo "Connecting to remote server $remote_xnat local project $local_project "
response=$(curl  -u $remote_user:$remote_pwd -X GET ''"$remote_url"'/data/services/tokens/issue')

secret=$(echo "$response" | jq -r '.secret')
alias=$(echo "$response" | jq -r '.alias')
exptime=$(echo "$response" | jq -r '.estimatedExpirationTime')




#PROXY_INFO
unset HTTP_PROXY
unset HTTPS_PROXY
unset http_proxy
unset https_proxy

#save token
echo "Saving credentials"
curl -u $xnat_admin_user:$xnat_admin_pwd -X POST --header 'Content-Type: text/plain' --header 'Accept: */*' -d '{
   "host":"'"$remote_url"'",
   "localProject":"'"$local_project"'",
   "remoteProject":"'"$hospital_code"'",
   "syncNewOnly":true,
   "alias":"'"$alias"'",
   "secret":"'"$secret"'",
   "username":"'"$remote_user"'",
   "estimatedExpirationTime":'"$exptime"'
}' 'http://127.0.0.1:8080/anon/xapi/xsync/credentials/save/projects/'"$local_project"''






#set project
echo "Saving project xsync settings"
curl -u $xnat_admin_user:$xnat_admin_pwd -X POST --header 'Content-Type: text/plain' --header 'Accept: text/plain' -d '{

  "project_resources": {
    "sync_type": "all"
  },
  "subject_resources": {
    "sync_type": "all"
  },
  "subject_assessors": {
    "sync_type": "all"
  },
  "imaging_sessions": {
    "sync_type": "all"
  },
  "enabled": true,
  "source_project_id": "'"$local_project"'",
  "sync_frequency": "on demand",
  "sync_new_only": true,
  "identifiers": "use_local",
  "remote_url": "'"$remote_url"'",
  "remote_project_id": "'"$hospital_code"'",
  "anonymize": false,
  "no_of_retry_days": 3,
  "customIdentifiers": "",
  "notification_emails": "",
  "project_resources.sync_type": "all",
  "subject_resources.sync_type": "all",
  "subject_assessors.sync_type": "all",
  "imaging_sessions.sync_type": "all"
}' 'http://127.0.0.1:8080/anon/xapi/xsync/setup/projects/'"$local_project"''




