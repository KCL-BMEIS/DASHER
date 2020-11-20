#!/usr/bin/env bash

dos2unix /data/xnat/scripts/clean_logs.sh
dos2unix /data/xnat/*
dos2unix /data/xnat/scripts/*
dos2unix /opt/scripts/*
dos2unix /data/xnat/home/xnat.cfg
dos2unix /data/xnat/home/config/*



source /data/xnat/home/xnat.cfg
hospital_code="$anon_project"
#for crontab job to run on windows.....


echo 'Starting setup script for '"$hospital_code"'' > /data/xnat/scripts/logs/setup-xnat.log

mv /data/xnat/scripts/plugins2/*.jar /data/xnat/home/plugins/

chown -R xnat:xnat /data
chown -R xnat:xnat /opt
rm -rf /opt/tomcat7/webapps/*
mv /opt/anon.war /opt/tomcat7/webapps/



#ensure postgresql started
sleep 100
##### PGRESTORE ON WINDOWS! ####
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
			psql -h xnat-db2 -p 5432 -U xnat  -f $sql_unpacked 
		fi
fi





echo 'Starting Server' >> /data/xnat/scripts/logs/setup-xnat.log
su - xnat -c "/opt/tomcat7/bin/catalina.sh run" &

# cron at end, else postgres backup will wipe previous.
echo 'Starting cron' >> /data/xnat/scripts/logs/setup-xnat.log
service cron start
crontab -u root /data/xnat/cronjobs.txt
touch /var/log/cron.log


echo 'Waiting for server to respond' >> /data/xnat/scripts/logs/setup-xnat.log

# it must be restarting server
if [ -f "/data/xnat/home/logs/access.log" ]; then
   mv /data/xnat/scripts/plugins2/*.jar /data/xnat/home/plugins/
   chown -R xnat:xnat /data
   chmod -R 775 /data/xnat/home/plugins/

   ##wait for war to unpack and database to build
   sleep 100

    a=0
    while [ $a -lt 1 ]
    do
    response=$(curl -u $xnat_admin_user:$xnat_admin_pwd  -X GET 'http://localhost:8080/anon/data/users')
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
    #wait for war to unpack and database to build
    sleep 100
    
    a=0
    while [ $a -lt 1 ]
    do
    response=$(curl -u admin:admin -X GET 'http://localhost:8080/anon/data/users')
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
  echo "Restarting server"  >> /data/xnat/scripts/logs/setup-xnat.log
  su - xnat -c "unzip /data/xnat/theme.zip -d /opt/tomcat7/webapps/anon/themes/"
  response=$(curl -u $xnat_admin_user:$xnat_admin_pwd  -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/anon/xapi/theme/xnat-anon?enabled=true')
  cat $response > /data/xnat/sctips/logs/theme-install.log

  #but assumes original image....
  sed -i  "s\xnat_admin_user.*\#\g"   /data/xnat/home/xnat.cfg
  sed -i  "s\xnat_admin_pwd.*\#\g"   /data/xnat/home/xnat.cfg
  sed -i  "s\xnat_pipe_\xnat_admin_\g"   /data/xnat/home/xnat.cfg

else
  echo "Initial Setup of Server" >> /data/xnat/scripts/logs/setup-xnat.log
  #### INSTALL THEME
  su - xnat -c "unzip /data/xnat/theme.zip -d /opt/tomcat7/webapps/anon/themes/"
  response=$(curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/anon/xapi/theme/xnat-anon?enabled=true')
  cat $response > /data/xnat/sctips/logs/theme-install.log


  #### ISNTALL SITECONFIG
  settings="$(cat /data/xnat/home/siteConfig.txt)"
  curl -u admin:admin -X POST --header 'Content-Type: application/json' --header 'Accept: */*' -d "$settings"  'http://localhost:8080/anon/xapi/siteConfig'

  #CRETAE TEST PROJECTS/SUBJECTS
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/anon/data/archive/projects/TEST'
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/anon/data/archive/projects/TEST/subjects/test'
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/anon/data/archive/projects/TEST/subjects/test/experiments/testsess?xnat:mrSessionData/date=01/01/10'

  ### CREATE PROJECT
  curl -u admin:admin -X PUT --header 'Accept: application/json' 'http://localhost:8080/anon/data/archive/projects/'"$hospital_code"''

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
  }' 'http://localhost:8080/anon/xapi/users'
  #ADD ADMIN USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "ALL_DATA_ADMIN",
    "TEST_owner",
    "'"$anon_projec"'_owner"
  ]' 'http://localhost:8080/anon/xapi/users/'"$xnat_admin_user"'/groups'
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "Administrator",
    "DataManager",
    "SiteUser"
  ]' 'http://localhost:8080/anon/xapi/users/'"$xnat_admin_user"'/roles'

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
  }' 'http://localhost:8080/anon/xapi/users'
  #ADD ADMIN USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "ALL_DATA_ADMIN",
    "TEST_owner",
    "'"$anon_project"'_owner"
  ]' 'http://localhost:8080/anon/xapi/users/'"$xnat_pipe_user"'/groups'
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "Administrator",
    "DataManager",
    "SiteUser"
  ]' 'http://localhost:8080/anon/xapi/users/'"$xnat_pipe_user"'/roles'



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
  }' 'http://localhost:8080/anon/xapi/users'
  #ADD USER TO HOSPITAL PROJECT
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d '[
    "'"$anon_projec"'_owner"
  ]' 'http://localhost:8080/anon/xapi/users/'"$xnat_user"'/groups'

  #### ISNTALL SITECONFIG
  settings="$(cat /data/xnat/home/siteConfig.txt)"
  curl -u  admin:admin  -X POST --header 'Content-Type: application/json' --header 'Accept: */*' -d "$settings"  'http://localhost:8080/anon/xapi/siteConfig'





    if [ "$use_proxy" = true ] 
    then
      /bin/bash  /data/xnat/setup-xsync-proxy.sh "$hospital_code" "$remote_xnat" "$remote_user" "$remote_pwd" > /data/xnat/scripts/logs/xsync_setup.log
    else
      /bin/bash  /data/xnat/setup-xsync.sh > /data/xnat/scripts/logs/xsync_setup.log
    fi


  #DISABLE ADMIN & GUEST
  curl -u admin:admin -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/anon/xapi/users/guest/enabled/false'
  curl -u $xnat_admin_user:$xnat_admin_pwd -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8080/anon/xapi/users/admin/enabled/false'

  sed -i  "s\xnat_admin_user.*\#\g"   /data/xnat/home/xnat.cfg
  sed -i  "s\xnat_admin_pwd.*\#\g"   /data/xnat/home/xnat.cfg
  sed -i  "s\xnat_pipe_\xnat_admin_\g"   /data/xnat/home/xnat.cfg

fi






while true
do
    
    sleep 3600000000

done
