#!/usr/bin/env bash

dos2unix /data/xnat/scripts/clean_logs.sh
dos2unix /data/xnat/*
dos2unix /data/xnat/scripts/*
dos2unix /opt/scripts/*
dos2unix /data/xnat/home/xnat.cfg
dos2unix /data/xnat/home/config/*




source /data/xnat/home/xnat.cfg


mv /data/xnat/scripts/plugins1/*.jar /data/xnat/home/plugins/
rm -rf /opt/tomcat7/webapps/*
mv /opt/ROOT.war /opt/tomcat7/webapps/


echo 'Starting setup script for '"$hospital_code"'' > /data/xnat/scripts/logs/setup-xnat.log
echo "XNAT_ADMIN=\"$xnat_pipe_user\"" > /data/xnat/home/.xnat
echo "XNAT_ADMIN_PWD=\"$xnat_pipe_pwd\"" >> /data/xnat/home/.xnat
chown -R xnat:xnat /data/xnat/home
chmod 600 /data/xnat/home/.xnat
chmod 600 /data/xnat/home/xnat.cfg


echo "export XNAT_ADMIN=\"$xnat_pipe_user\"" >> /data/xnat/home/.bash_profile
echo "export XNAT_ADMIN_PWD=\"$xnat_pipe_pwd\"" >> /data/xnat/home/.bash_profile
echo "export XNAT_ADMIN=\"$xnat_pipe_user\"" >> /root/.bash_profile
echo "export XNAT_ADMIN_PWD=\"$xnat_pipe_pwd\"" >> /root/.bash_profile
chmod 600 /data/xnat/home/.bash_profile
export PGPASSWORD="$psql_pwd"
export XNAT_ADMIN="$xnat_pipe_user"
export XNAT_ADMIN_PWD="$xnat_pipe_pwd"

chown -R xnat:xnat /data
chown -R xnat:xnat /opt






#ensure postgresql started

sleep 100

##### PGRESTORE ON WINDOWS! HAve to do beforehand ####
if [ -d "/pg_backup" ]; then 
		export PGPASSWORD=$psql_pwd
		for folder in /pg_backup/*
		do
		   sql_file=$(find "$folder" -exec stat \{} --printf="%n \n" \; | sort -n -r  | head -1) 
		done
		if [[ $sql_file = *".sql.gz"* ]]; then	
			gunzip -k -f $sql_file
			sql_unpacked="${sql_file/.gz/}" 
			echo "Windows: Backup database file detected. Restoring database using  $sql_unpacked" >> /data/xnat/scripts/logs/setup-xnat.log
			psql -h xnat-db1 -p 5432 -U xnat  -f $sql_unpacked 
		fi
fi

echo 'Starting Server' >> /data/xnat/scripts/logs/setup-xnat.log
su - xnat -c "/opt/tomcat7/bin/catalina.sh run" &

su - xnat -c "storescp  -aet XNAT -od /data/xnat/import_data -ss diverter 8104" &

echo 'Starting cron' >> /data/xnat/scripts/logs/setup-xnat.log
service cron start
crontab -u root /data/xnat/cronjobs.txt
touch /var/log/cron.log




echo 'Waiting for server to respond' >> /data/xnat/scripts/logs/setup-xnat.log

# it must be restarting server
if [ -f "/data/xnat/home/logs/access.log" ]; then
   mv /data/xnat/scripts/plugins1/*.jar /data/xnat/home/plugins/
   chown -R xnat:xnat /data
   chmod -R 775 /data/xnat/home/plugins/

   ##wait for war to unpack and database to build
   sleep 100

    a=0
    while [ $a -lt 1 ]
    do
    response=$(curl -u $xnat_admin_user:$xnat_admin_pwd  -X GET 'http://localhost:8080/data/users')
    echo "Response from curl: $response"
    if [[ $response = *"$xnat_admin_user"* ]]; then
      a=10
      echo "############################"
    else
      echo "ERROR DETECTED" 
      a=0
    fi
    done


else
    ##wait for war to unpack and database to build
    sleep 100

    a=0
    while [ $a -lt 1 ]
    do
    response=$(curl -u admin:admin -X GET 'http://localhost:8080/data/users')
    echo "Response from curl: $response"
    if [[ $response = *"admin"* ]]; then
      a=10
      echo "############################"
    else
      echo "ERROR DETECTED" 
      a=0
    fi
    done
fi

echo "Server Started" >> /data/xnat/scripts/logs/setup-xnat.log




if [[ $response = *"$xnat_user"* ]]; then
   # skip setup, just upload resources
   echo "Restarting server" >> /data/xnat/scripts/logs/setup-xnat.log
  /bin/bash  /data/xnat/upload-resources.sh   

  
else

   echo "Initial Setup of Server" >> /data/xnat/scripts/logs/setup-xnat.log
   #CRETAE TEST PROJECTS/SUBJECTS
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/data/archive/projects/QUARANTINE'
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/data/archive/projects/QUARANTINE/subjects/test'
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/data/archive/projects/QUARANTINE/subjects/test/experiments/testsess?xnat:mrSessionData/date=01/01/10'

  

  ### CREATE PROJECT
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/data/archive/projects/'"$hospital_code"''

  echo "Creating Users" >> /data/xnat/scripts/logs/setup-xnat.log
  #CREATE ADMIN USER
  curl -u admin:admin -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
    "email": "'"$xnat_admin_email"'",
    "enabled": true,
    "firstName": "xnat",
    "lastModified": "2018-07-06T10:02:52.090Z",
    "lastName": "xnat",
    "lastSuccessfulLogin": "2018-07-06T10:02:52.090Z",
    "password": "'"$xnat_admin_pwd"'",
    "username": "'"$xnat_admin_user"'",
    "verified": true
  }' 'http://localhost:8080/xapi/users'
  #ADD ADMIN USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "ALL_DATA_ADMIN",
    "QUARANTINE_owner",
    "'"$hospital_code"'_owner"
  ]' 'http://localhost:8080/xapi/users/'"$xnat_admin_user"'/groups'
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "Administrator",
    "DataManager",
    "SiteUser"
  ]' 'http://localhost:8080/xapi/users/'"$xnat_admin_user"'/roles'

  #CREATE ADMIN USER
  curl -u admin:admin -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
    "email": "'"$xnat_admin_email"'",
    "enabled": true,
    "firstName": "xnat",
    "lastModified": "2018-07-06T10:02:52.090Z",
    "lastName": "xnat",
    "lastSuccessfulLogin": "2018-07-06T10:02:52.090Z",
    "password": "'"$xnat_pipe_pwd"'",
    "username": "'"$xnat_pipe_user"'",
    "verified": true
  }' 'http://localhost:8080/xapi/users'
  #ADD ADMIN USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "ALL_DATA_ADMIN",
    "QUARANTINE_owner",
    "'"$hospital_code"'_owner"
  ]' 'http://localhost:8080/xapi/users/'"$xnat_pipe_user"'/groups'
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "Administrator",
    "DataManager",
    "SiteUser"
  ]' 'http://localhost:8080/xapi/users/'"$xnat_pipe_user"'/roles'

  #CREATE NON-ADMIN USER
  curl -u admin:admin -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
    "email": "'"$xnat_admin_email"'",
    "enabled": true,
    "firstName": "xnat",
    "lastModified": "2018-07-06T10:02:52.090Z",
    "lastName": "xnat",
    "lastSuccessfulLogin": "2018-07-06T10:02:52.090Z",
    "password": "'"$xnat_pwd"'",
    "username": "'"$xnat_user"'",
    "verified": true
  }' 'http://localhost:8080/xapi/users'
  #ADD USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "QUARANTINE_collaborator",
    "'"$hospital_code"'_member"
  ]' 'http://localhost:8080/xapi/users/'"$xnat_user"'/groups'


  echo "Installing Config File" >> /data/xnat/scripts/logs/setup-xnat.log
  #### INSTALL SITECONFIG
  settings="$(cat /data/xnat/home/siteConfig.txt)"
  curl -u admin:admin  -X POST --header 'Content-Type: application/json' --header 'Accept: */*' -d "$settings"  'http://localhost:8080/xapi/siteConfig'

  #### INSTALL dicom reciever ####
  scp='{
    "aeTitle": "XNAT",
    "enabled": true,
    "id": 1,
    "identifier": "UploaderDicomObjectIdentifier",
    "port": 8105
  }'
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: */*' -d "$scp"  'http://localhost:8080/xapi/dicomscp/1'


  curl -u admin:admin -X PUT -d '[
   {"name":"Clinical Trials","description":"Clinical Trial list and label files","type":"xnat:projectData","label":"clinical_trials","subdir":"","overwrite":true}
   ]' 'http://localhost:8080/data/projects/'"$hospital_code"'/config/resource_config/script?inbody=true'




  #DISABLE ADMIN & GUEST
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/xapi/users/guest/enabled/false'
  curl -u $xnat_admin_user:$xnat_admin_pwd -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/xapi/users/admin/enabled/false'



  python3 /opt/scripts/import_data.py test



  echo "Pushing test data" >> /data/xnat/scripts/logs/setup-xnat.log
  #/opt/DicomBrowser-1.5.2/bin/DicomRemap  -o dicom://XNAT@127.0.0.1:8104/XNAT /data/xnat/import_data/test_data > /data/xnat/scripts/logs/dicom_push_test.log
	a=0
  attempts=0
	while [ $a -lt 1 ]
	do 
    if [ $attempts -gt 50 ]; then 
       a=10
	  elif [ -d "/data/xnat/archive/${hospital_code}/arc001" ]; then 
	     a=10
	  fi
	  sleep 20
    attempts=$((attempts+1))
    echo "Attempting to check archived data, attempt $attempts" >> /data/xnat/scripts/logs/dicom_push_test.log
	done
	sleep 60
  echo "Test data imported, testing scripts" >> /data/xnat/scripts/logs/setup-xnat.log
  ## need to do process_rt_struct as this sets default clinical trial IDS
  chown -R xnat:xnat /data
  su - xnat -c "/opt/scripts/process-rtstruct.sh uploader_S00002 uploader_E00002 zzsabrSPINE $hospital_code  > /data/xnat/scripts/logs/test_rtstruct.log"
	su - xnat -c "/opt/scripts/export-anon-data.sh $hospital_code TestTrial  TestSubject TestSession uploader_S00002 zzsabrSPINE $anon_project 0  > /data/xnat/scripts/logs/test_anon.log"
    
  #upload clinical trial info
  
  /bin/bash  /data/xnat/upload-resources.sh
fi

#stop 



sed -i  "s\xnat_admin_user.*\#\g"   /data/xnat/home/xnat.cfg
sed -i  "s\xnat_admin_pwd.*\#\g"   /data/xnat/home/xnat.cfg
sed -i  "s\xnat_pipe_\xnat_admin_\g"   /data/xnat/home/xnat.cfg

while true
do
    
    #### check import_data folder    
    echo "Starting import script" >> /data/xnat/scripts/logs/setup-xnat.log
    #sleep 10000000
    python3 /opt/scripts/import_data.py 

    

done
