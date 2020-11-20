source /data/xnat/home/xnat.cfg

remote_user="xnat"
remote_pwd="xnat"
local_project="$anon_project"

#get token
echo "Connecting to remote server $remote_xnat local project $local_project "
response=$(curl  -u $remote_user:$remote_pwd -X GET ''"$remote_xnat"'/data/services/tokens/issue')

secret=$(echo "$response" | jq -r '.secret')
alias=$(echo "$response" | jq -r '.alias')
exptime=$(echo "$response" | jq -r '.estimatedExpirationTime')



#save token
echo "Saving credentials"
curl -u admin:admin -X POST --header 'Content-Type: text/plain' --header 'Accept: text/plain' -d '{
   "host":"'"$remote_xnat"'",
   "localProject":"'"$local_project"'",
   "remoteProject":"'"$hospital_code"'",
   "syncNewOnly":"true",
   "alias":"'"$alias"'",
   "secret":"'"$secret"'",
   "username":"'"$remote_user"'",
   "estimatedExpirationTime"::'"$exptime"'
}' 'http://127.0.0.1:8080/anon/xapi/xsync/credentials/save/projects/'"$local_project"''






#set project
echo "Saving project xsync settings"
curl -u admin:admin -X POST --header 'Content-Type: text/plain' --header 'Accept: text/plain' -d '{

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
  "remote_url": "'"$remote_xnat"'",
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

