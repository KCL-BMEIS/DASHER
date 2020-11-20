#!/bin/bash

url="http://xnat-web2:8080"
project=$1
ct_id=$2
ct_subject=$3
ct_session=$4
subject_id=$5
session_label=$6
### date removed as some sesisons do not have one date due to planning etc.
dte="2000-01-01"
anon_project=$7
benchmark=$8

NOW=`date +'%Y%m%d'`

if [[ $project != *version*  ]]; then

    num_dirs=$(find "/data/xnat/scripts/pipelines/running/" -type d | wc -l)
    while [ "$num_dirs" -gt 4 ]
    do
        sleep 30
        num_dirs=$(find "/data/xnat/scripts/pipelines/running/" -type d | wc -l)
    done
    mkdir /data/xnat/scripts/pipelines/running/$ct_session-$session_label


    
    #anonymise the data to a folder to upload..
    #path="/data/xnat/anon/$ct_session" - no, as messes up auto anon!!!
    #echo "./export-anon-data.sh $project $ct_id $ct_subject $ct_session $subject_id  $session_label $dte $anon_project"
    echo "### Exporting anonymised data: benchmark: $benchmark anon_project: $anon_project proj: $project, ctid: $ct_id, ctsub: $ct_subject, ct ses: $ct_session, subject_id: $subject_id, session_label: $session_label ###" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    path="/data/xnat/cache/temp/$subject_id$session_label"
    path_anon="$path-anon"
    
    rm -R $path
    rm -R $path_anon
    mkdir $path

    if [ "$ct_id" = "__GENERATE__" ]; then
    sleep 90
    fi;

    #echo "java -jar /opt/scripts/dicom-edit6-1.2.0-SNAPSHOT-jar-with-dependencies.jar -s /data/xnat/scripts/anon.das  -o $path  -i /data/xnat/archive/$project/arc001/$session_label/SCANS" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    #java -jar /opt/scripts/dicom-edit6-1.2.0-SNAPSHOT-jar-with-dependencies.jar -s /data/xnat/scripts/anon.das  -o $path  -i /data/xnat/archive/$project/arc001/$session_label/SCANS >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log

    echo "/opt/DicomBrowser-1.5.2/bin/DicomRemap  -d /data/xnat/scripts/anon.das  -o $path /data/xnat/archive/$project/arc001/$session_label/SCANS" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    /opt/DicomBrowser-1.5.2/bin/DicomRemap  -d /data/xnat/scripts/anon.das  -o $path /data/xnat/archive/$project/arc001/$session_label/SCANS


    #upooad assessors and scans using python script
    echo "python3 /opt/scripts/anonymise_using_pydicom.py  $ct_id $ct_subject $ct_session  $path  $benchmark" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    python3 /opt/scripts/anonymise_using_pydicom.py  "$ct_id" "$ct_subject" "$ct_session"  "$path"  "$benchmark" 

    path_anon="$path-anon"

    if python3 /opt/scripts/compare_dicoms.py $project $session_label $path_anon  ; then
        echo "Successfully anonymised data" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    else
        echo "dicoms not anonymised" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
        rm -R $path_anon
        rm -R /data/xnat/scripts/pipelines/running/$ct_session-$session_label
        exit 1
    fi

    #python /data/xnat/scripts/export-anon-data.py "$xnat_admin_user" "$xnat_admin_pwd" "$ct_id" "$ct_subject" "$ct_session" "$project" "$subject_id" "$session_label" "$dte" "$path_anon" 
    #upooad assessors and scans using python script
    echo "python3 /opt/scripts/export-anon-data.py  $ct_id $ct_subject $ct_session $project $subject_id $session_label $dte $path_anon $anon_project $benchmark" >> /data/xnat/scripts/logs/export-anon-data_sh_${NOW}.log
    if python3 /opt/scripts/export-anon-data.py  "$ct_id" "$ct_subject" "$ct_session" "$project" "$subject_id" "$session_label" "$dte" "$path_anon" "$anon_project" "$benchmark" ; then
        echo "Successfully exported data"
    else
        echo "Pipeline failed in export-anon-data.py. Check logs."
        rm -R $path_anon
        rm -R /data/xnat/scripts/pipelines/running/$ct_session-$session_label
        #curl $curl_params -X DELETE  "$url/data/projects/$project/subjects/$ct_subject/experiments/$ct_session"
        exit 1
    fi


    rm -R $path_anon
    rm -R /data/xnat/scripts/pipelines/running/$ct_session-$session_label
    exit 0

fi