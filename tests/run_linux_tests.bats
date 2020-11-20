#!/usr/bin/env bats

pwd=$(pwd)

config_file=../xnat.cfg
test_data=test_data
if [ -f "$config_file" ]; then
    test_data=../tests/test_data
    source $config_file
    if [[ "$storage_path" = *"."* ]]; then
        storage_path=${pwd/tests/$storage_path}
    fi
    if [[ "$import_data_folder"  = *"."* ]]; then
        import_data_folder=${pwd/tests/$import_data_folder}
    fi        
else
    config_file=xnat.cfg
    if [ -f "$config_file" ]; then
        source $config_file
        test_data=./tests/test_data
    else
        exit -1
    fi
fi

anon_port="8082"
if [ "$ssl" = true ] 
then
    anon_port="444"
fi


cont1=$(docker ps | egrep xnat-web1 | cut -c1-12)
cont2=$(docker ps | egrep xnat-web2 | cut -c1-12)


 

#### check the images and containers exists
images=$(docker image ls)
containers=$(docker ps)


@test "Wait for setup to complete before tests start" {
    cp -R $test_data $import_data_folder
    seq 1 1200 | while read i; do 
        sleep 1
    done
    [[ $images = *"nginx"* ]]
}
@test "Checking nginx image exists" {
    [[ $images = *"nginx"* ]]
}
@test "Checking postgresql image exists" {
    [[ $images = *"postgres"* ]]
}
@test "Checking xnat1 image exists" {
    [[ $images = *"xnat1"* ]]
}
@test "Checking xnat2 image exists" {
    [[ $images = *"xnat2"* ]]
}

@test "Checking nginx container exists" {
    [[ $containers = *"nginx"* ]]
}
@test "Checking postgresql1 container exists" {
    [[ $containers = *"xnat-db1"* ]]
}
@test "Checking postgresql2 container exists" {
    [[ $containers = *"xnat-db2"* ]]
}
@test "Checking xnat1 container exists" {
    [[ $containers = *"xnat-web1"* ]]
}
@test "Checking xnat2 container exists" {
    [[ $containers = *"xnat-web2"* ]]
}



### check shred file system created and exists



@test "Checking postgresql1 database files exist" {
    file="$storage_path/postgres-data1/PG_VERSION"
    
    [ -f "$file" ]
}


@test "Checking postgresql2 database files exist" {
    file="$storage_path/postgres-data2/PG_VERSION"
    [ -f "$file" ]
}


@test "Checking tomcat1 logs created in XNAT home directory" {
    file="$storage_path/tomcat_logs1/application.log"
    [ -f "$file" ]
}

@test "Checking tomcat2 logs created in XNAT home directory" {
    file="$storage_path/tomcat_logs2/application.log"
    [ -f "$file" ]
}

@test "Checking the xnat user is created and XNAT Rest API works for XNAT 1" {
    response=$(docker exec -it "$cont1" curl -u $xnat_admin_user:$xnat_admin_pwd -X GET 'http://localhost:8080/data/users')
    
    [[ $response = *"$xnat_admin_user"* ]]
}
@test "Checking the xnat user is created and XNAT Rest API works for XNAT 2" {
    response=$(docker exec -it "$cont2" curl -u $xnat_admin_user:$xnat_admin_pwd -X GET 'http://localhost:8080/anon/data/users')
    [[ $response = *"$xnat_admin_user"* ]]
}



@test "Checking archive directory created and QUARANTINE project created" {
    directory="$storage_path/archive1/QUARANTINE/arc001"
    [ -d "$directory" ]
}

@test "Checking test data is imported." {
    directory="$storage_path/archive1/$hospital_code/arc001/zzsabrSPINE"
    ## see if exists in log folder....
    [ -d "$directory" ]
}

@test "Checking to see if annoymisation script succeds" {
    HC="$anon_project"
    directory="$storage_path/archive2/$HC/arc001/TestSession"
    [ -d "$directory" ]
}

@test "Deleting test data" {
    HC="$hospital_code"
    response=$(docker exec -it "$cont2" curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE 'http://localhost:8080/anon/data/projects/TEST')
    response=$(docker exec -it "$cont1" curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE 'http://localhost:8080/data/projects/QUARANTINE/subjects/uploader_S00001')
    response=$(docker exec -it "$cont2" curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE "http://localhost:8080/anon/data/projects/${anon_project}/subjects/uploader_anon_S00002")
	response=$(docker exec -it "$cont1" curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE "http://localhost:8080/data/projects/${HC}/subjects/uploader_S00002")
    directory="$storage_path/archive1/${HC}/arc001/zzsabrSPINE"
    rm -rf "$directory"
    directory="$storage_path/archive2/${anon_project}/arc001/TestSession"
    rm -rf "$directory"
    [[ $response != *"error"* ]]
}

#@test "Checking anaonymisation shell script runs without error" {
#    #### argh has to be run within container....
#    #run "$volumes/scripts1/export-anon-data.sh UCLH test_ct_id  test_sub test_ses xnat_S00003 ZZZspine 1990-01-01"
#    [ "$status" -eq 1 ]
#}

#@test "Checking anonymisation transffered to anon site" {
#    directory="$volumes/archive2/UCLH/arc001/test_ses"
#    sleep 250
#    ## see if exists in log folder....
#    [ -d "$directory" ]
#}




