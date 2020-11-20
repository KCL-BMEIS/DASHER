#!/usr/bin/env bash
linux_dir=$(dirname "$0")
cd $linux_dir
cd ..
uploader_dir=$(pwd)
if [ ! -f "$uploader_dir/Linux/build.sh" ]
then
        echo "Error: You must run the build.sh script from the same directory as the script."
        exit 1
fi

if [ ! -f "$uploader_dir/xnat.cfg" ]
then
        echo "Error: Cannot find xnat.cfg file"
        exit 1
fi
 


dos2unix $uploader_dir/xnat.cfg
source $uploader_dir/xnat.cfg

# echo "p1:$xnat_admin_pwd p2:$xnat_pwd  p3:$psql_pwd"
xnat_name="uploader"
psql_user=xnat


chmod 770 $uploader_dir/Linux/clean_docker.sh

echo "### CHECKING to see if shared folders exist   ###"
if [ -d "$storage_path" ]
then
    echo "Storage path already exists. Use restart_and_clean.sh or restart.sh"
    exit 1
fi

echo "### CHECKING XNAT.CFG FILE FOR ERRORS - $xnat_host   ###"

if [  "$ssl" = true ] && [[ "$xnat_host" != "https://"*  ]]
then
        echo "Error: URL malformed, SSL selected but URL does not start with https://"
        exit 1
fi
if [  "$ssl" = false ] && [[ "$xnat_host" != "http://"* ]]
then
    echo "Error: URL malformed, does not start with http://"
    exit 1
fi 

if [ ${#storage_path} -le 2 ]
then
    echo "Error: Check xnat.cfg - storage_path too short - path: $storage_path "
    exit 1
fi
if [ ${#import_data_folder} -le 2 ]
then
    echo "Error: Check xnat.cfg - import_data_folder too short - path: $import_data_folder"
    exit 1
fi

if [ "$xnat_admin_user" = "admin" ]
then
    echo "Error: Check xnat.cfg - xnat_admin_user cannot be admin"
    exit 1
fi

if [ ${#xnat_user} -le 2 ]
then
    echo "Error: Check xnat.cfg - xnat_user too short"
    exit 1
fi
if [ ${#xnat_pwd} -le 4 ]
then
    echo "Error: Check xnat.cfg - xnat_pwd too short"
    exit 1
fi

if [[ "$xnat_admin_user" = "admin" ]]
then
    echo "Error: Check xnat.cfg - xnat_admin_user cannot be admin"
    exit 1
fi


if [ ${#xnat_admin_user} -le 2 ]
then
    echo "Error: Check xnat.cfg - xnat_admin_user too short"
    exit 1
fi
if [ ${#xnat_admin_pwd} -le 4 ]
then
    echo "Error: Check xnat.cfg - xnat_admin_pwd too short"
    exit 1
fi

if [ ${#psql_pwd} -le 4 ]
then
    echo "Error: Check xnat.cfg - psql_pwd too short"
    exit 1
fi

if [ ${#hospital_code} -le 2 ]
then
    echo "Error: Check xnat.cfg - hospital_code too short"
    exit 1
fi

if [ ${#anon_project} -le 2 ]
then
    echo "Error: Check xnat.cfg - anon_project too short - path: $anon_project"
    exit 1
fi

if [ "$ssl" = true ]
then
    if [ ${#ssl_key_file} -le 2 ]
    then
        echo "Error: Check xnat.cfg - ssl key file missing "
        exit 1
    fi
        if [ ${#ssl_crt_file} -le 2 ]
    then
        echo "Error: Check xnat.cfg - ssl crt file missing "
        exit 1
    fi
    if [ ${#ssl_trust_file} -le 2 ]
    then
        echo "Error: Check xnat.cfg - ssl trust file missing "
        exit 1
    fi
    if [[ "$ssl_key_file" = *"/"* ]]
    then
        echo "Error: Check xnat.cfg - ssl key file contains a file seperator - only include the filename"
        exit 1
    fi

    if [[ "$ssl_crt_file" = *"/"* ]]
    then
        echo "Error: Check xnat.cfg - ssl crt file contains a file seperator - only include the filename"
        exit 1
    fi

    if [[ "$ssl_trust_file" = *"/"* ]]
    then
        echo "Error: Check xnat.cfg - ssl trust file contains a file seperator - only include the filename"
        exit 1
    fi

fi




stacks=$(docker stack ls)
if [[ $stacks = *"secure-dicom"* ]]; then
    echo "### uploader already running.... stopping current service and rebuilding###" 
	docker stack rm secure-dicom-uploader
	sleep 60
fi


docker swarm leave


echo "### Installing XNAT_CTP UPLOADER    ###"
echo "### Using config file xnat.cfg      ###"
echo "# Host:  $xnat_host            ###"
echo "# Local Project: $hospital_code      ###"
echo "# storage path:  $storage_path            ###"
echo "# admin user:  $xnat_admin_user            ###"
echo "# admin email:  $xnat_admin_email            ###"



mkdir -p $storage_path/
mkdir -p $storage_path/certificates/
mkdir -p $storage_path/archive1/
mkdir -p $storage_path/archive2/
mkdir -p $storage_path/postgres-data1/
mkdir -p $storage_path/postgres-data2/
mkdir -p $storage_path/scripts1/
mkdir -p $storage_path/scripts2/
mkdir -p $storage_path/tomcat_logs1/
mkdir -p $storage_path/tomcat_logs2/
mkdir -p $storage_path/nginx_logs/
mkdir -p $import_data_folder
chmod 777 $import_data_folder

if [ -d "$storage_path" ]
then
    echo "Success: storage path created"
else
    echo "Error: No storage path created"
    exit 1
fi
if [ -d "$import_data_folder" ]
then
    echo "Success: storage path created"
else
    echo "Error: No storage path created"
    exit 1
fi
anon_port="8082"
if [ "$ssl" = true ] 
then
    anon_port="444"
# Check file names


fi




### need to edit setup_xnat.sh...
cp xnat.cfg ./xnat/xnat.cfg
cp ./xnat/templates/prefs-init.ini-template ./xnat/conf1/prefs-init.ini
cp ./xnat/templates/prefs-init.ini-template ./xnat/conf2/prefs-init.ini
cp ./xnat/templates/site-config-template ./xnat/conf2/siteConfig.txt
cp ./xnat/templates/site-config-template ./xnat/conf1/siteConfig.txt
cp ./xnat/templates/gradle.properties-template ./xnat/conf1/gradle.properties
cp ./xnat/templates/gradle.properties-template ./xnat/conf2/gradle.properties
cp ./xnat/templates/xnat-conf.properties-template ./xnat/conf1/xnat-conf.properties
cp ./xnat/templates/xnat-conf.properties-template ./xnat/conf2/xnat-conf.properties
cp ./xnat/templates/cronjobs-template ./xnat/cronjobs.txt


URL=$xnat_host
#sed -i -e '/@SIF@/{r ./xnat/SeriesImportFilter.txt' -e 'd}'  ./xnat/conf2/siteConfig.txt ./xnat/conf1/siteConfig.txt
sed -i "s/@XNAT_ADMIN_USER@/$xnat_admin_user/g"  ./xnat/conf1/prefs-init.ini ./xnat/conf1/siteConfig.txt ./xnat/conf2/prefs-init.ini ./xnat/conf2/siteConfig.txt ./xnat/conf1/gradle.properties ./xnat/conf2/gradle.properties
sed -i "s#@SITEURL@#$URL#g"                  ./xnat/conf1/prefs-init.ini ./xnat/conf1/siteConfig.txt  ./xnat/conf1/gradle.properties
sed -i "s#@SITEURL@#$URL:$anon_port/anon/#g" ./xnat/conf2/prefs-init.ini ./xnat/conf2/siteConfig.txt  ./xnat/conf2/gradle.properties


sed -i "s#@PIPELINE_URL@#http://localhost:8080/#g" ./xnat/conf1/gradle.properties ./xnat/conf1/siteConfig.txt
sed -i "s#@PIPELINE_URL@#http://localhost:8080/anon#g" ./xnat/conf2/gradle.properties ./xnat/conf2/siteConfig.txt


sed -i "s#@SITEURLNA@#$URL#g" ./xnat/conf1/siteConfig.txt ./xnat/conf2/siteConfig.txt  
sed -i "s#@SITEURLPA@#$URL:$anon_port/anon/#g" ./xnat/conf1/siteConfig.txt ./xnat/conf2/siteConfig.txt  


sed -i "s/@ADMIN_EMAIL@/$xnat_admin_email/g" ./xnat/conf1/prefs-init.ini ./xnat/conf1/siteConfig.txt ./xnat/conf2/prefs-init.ini ./xnat/conf2/siteConfig.txt ./xnat/conf1/gradle.properties ./xnat/conf2/gradle.properties
sed -i "s/@PROJECT@/$hospital_code/g"  ./xnat/conf1/siteConfig.txt ./xnat/conf2/siteConfig.txt
sed -i "s/@DB_NUM@/1/g"  ./xnat/conf1/xnat-conf.properties
sed -i "s/@DB_NUM@/2/g"  ./xnat/conf2/xnat-conf.properties
sed -i "s/@PG_USR@/$psql_user/g"  ./xnat/conf1/xnat-conf.properties ./xnat/conf2/xnat-conf.properties
sed -i "s/@PG_PWD@/$psql_pwd/g"  ./xnat/conf1/xnat-conf.properties ./xnat/conf2/xnat-conf.properties


sed -i  "s/@SITE@/$xnat_name/g"        ./xnat/conf1/gradle.properties ./xnat/conf1/prefs-init.ini ./xnat/conf1/siteConfig.txt
sed -i  "s/@SITE@/anon/g"   ./xnat/conf2/gradle.properties ./xnat/conf2/prefs-init.ini ./xnat/conf2/siteConfig.txt





# NGINX ssl config
NGINX_CONF='./nginx/xnat.conf'
if [ "$ssl" = true ] 
then
    echo "Nginx configured for https, secure site"
    cp ./nginx/xnat_ssl.conf ./nginx/xnat.conf
else
    echo "# Nginx configured for http, no ssl configuration"
    cp ./nginx/xnat_nonssl.conf ./nginx/xnat.conf
fi
nginx_host="${xnat_host/http*:\/\//}"
echo "## nginx host: $nginx_host"
sed -i  "s#@SERVER_NAME@#$nginx_host#g"   "$NGINX_CONF"
sed -i  "s/@CRT@/$ssl_crt_file/g"   "$NGINX_CONF"
sed -i  "s/@KEY@/$ssl_key_file/g"  "$NGINX_CONF"
sed -i  "s/@PEM@/$ssl_dhparem_file/g"  "$NGINX_CONF"
sed -i  "s/@TRUST@/$ssl_trust_file/g"  "$NGINX_CONF"


# docker compse, set volume path
DOCKER_FILE='docker-compose.yml'
cp docker-compose-template.yml docker-compose.yml
sed -i  "s/#LINX//g"   "$DOCKER_FILE"
sed -i  "s#./volume#$storage_path#g"   "$DOCKER_FILE"
sed -i  "s#@IMPORT_DATA_FOLDER@#$import_data_folder#g"   "$DOCKER_FILE"
sed -i "s/@PG_PWD@/$psql_pwd/g"   "$DOCKER_FILE" 
sed -i "s/@PG_USER@/$psql_user/g"   "$DOCKER_FILE" 

## COPY PLUGINS AND WEBAPPS
cp -r ./plugins1  $storage_path/scripts1/
cp -r ./plugins2  $storage_path/scripts2/


if [  "$ssl" = true ] 
then
    cp ./certs/* $storage_path/certificates/
fi


cp -r ./scripts/* $storage_path/scripts1/
mkdir -p $storage_path/scripts2/pipelines/
cp ./scripts/clean_logs.sh $storage_path/scripts2/
#cp ./xnatscripts/delete_dicom_files.sh $storage_path/scripts2/
cp -r ./scripts/pipelines/* $storage_path/scripts2/pipelines/

mkdir -p $storage_path/scripts1/logs/
mkdir -p $storage_path/scripts2/logs/
mkdir -p $storage_path/scripts1/access_logs/
mkdir -p $storage_path/scripts2/access_logs/


### create XNAT pipe user
random1=$(shuf -i 2000-65000 -n 1)
random2=$(shuf -i 2000-65000 -n 1)
echo "xnat_pipe_user=xnat_pipe"  >> ./xnat/xnat.cfg
echo "xnat_pipe_pwd=$random1$xnat_admin_pwd$random2" >> ./xnat/xnat.cfg

#### SET PROXY
#maybe copy entire directory and run - xnat_proxy

if [ "$use_proxy" = true ] 
then
    echo "# Using proxy $proxy_url:$proxy_port"
    #JAVA_PROXY=' -Dhttp.proxyHost=$proxy_url  -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_url  -Dhttps.proxyPort=$proxy_port   -Dhttp.nonProxyHosts=\"localhost|127.0.0.1|xnat-web1|xnat-web2|$nginx_host\" '
    JAVA_PROXY=" -Dhttp.proxyHost=$proxy_url  -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_url  -Dhttps.proxyPort=$proxy_port   -Dhttp.nonProxyHosts=\\\"localhost|127.0.0.1|xnat-web1|xnat-web2\\\" "
    
    rm -rf  ./xnat_proxy
    cp -R ./xnat ./xnat_proxy
    sed -i  "s\#ENV \ENV \g"   ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i "s#@PROXYURL@#$proxy_url#g"   ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i "s#@PROXYPORT@#$proxy_port#g"   ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i  "s\@JAVA_PROXY@\ $JAVA_PROXY \g"   ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i  "s\#RUN su - \RUN su -  \g"   ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i  "s\setup-xsync.sh\setup-xsync-proxy.sh\g"   ./xnat_proxy/conf2/setup-xnat.sh

   


    echo "# Using proxy - changing pipeline cfg"
    ###### pipeline install - no http/https
    sed -i  "s#gradlew#gradlew $JAVA_PROXY #g" ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i  "s#=http://#=#g" ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    sed -i  "s#=https://#=#g" ./xnat_proxy/Dockerfile1 ./xnat_proxy/Dockerfile2
    
    # bash rpofile
    echo "# Using proxy - changing bash_profile"
    echo "export HTTPS_PROXY=\"$proxy_url:$proxy_port\"" >>   ./xnat_proxy/bash_profile
    echo "export https_proxy=\"$proxy_url:$proxy_port\"" >>   ./xnat_proxy/bash_profile
    echo "export ftp_proxy=\"$proxy_url:$proxy_port\"" >>   ./xnat_proxy/bash_profile
    echo "export FTP_PROXY=\"$proxy_url:$proxy_port\"" >>   ./xnat_proxy/bash_profile
    
    ## NO PROXY - nginx_host defeined earlier, it's xnat_host with http/s stripped
    echo "export no_proxy=\"localhost,127.0.0.1,xnat-web1,xnat-web2\"" >>   ./xnat_proxy/bash_profile
    echo "export NO_PROXY=\"localhost,127.0.0.1,xnat-web1,xnat-web2\"" >>   ./xnat_proxy/bash_profile


    echo "export JAVA_OPTS=\"\${JAVA_OPTS}  $JAVA_PROXY \"" >>   ./xnat_proxy/setenv.sh
    # should be just java_opts, as that is default
    echo "export CATALINA_OPTS=\"\${CATALINA_OPTS}  $JAVA_PROXY \"" >>   ./xnat_proxy/setenv.sh
    
   cd xnat_proxy
else
   cd xnat
fi






docker build -f Dockerfile1 -t xnat1 .
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
docker build -f Dockerfile2 -t xnat2 .
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
cd ..
cd nginx
docker build -t nginx-xnat1 .
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
cd ..
cd postgres
docker build -f Dockerfile -t postgres-xnat .
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
cd ..
docker swarm init


docker stack deploy -c docker-compose.yml secure-dicom-uploader
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

echo "completed build"



test=$1
if [ "$test" != "test" ]
then
    echo "###### RUNNING TESTS #######################"
    echo "###### PLEASE BE PATIENT, THIS WILL TAKE TIME#######"
    echo "#### Tests will commence in 1200 seconds ####"

    cd tests
    bats run_linux_tests.bats
	### delete xnat.cfg passwords
	###disabled for testsing
    cd ..
	sed -i 's/_pwd=.*/_pwd=/g' xnat.cfg ./xnat/xnat.cfg
    sed -i 's/_pwd_research=.*/_pwd_research=/g' xnat.cfg ./xnat/xnat.cfg
    rm ./xnat/conf1/*.properties
    rm ./xnat/conf2/*.properties
	
	cd Linux
    


fi







