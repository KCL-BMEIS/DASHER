#!/bin/bash
session_id=$1
session_label=$2
project=$3


if [[ $project != *version*  ]]; then

    mkdir /data/xnat/scripts/pipelines/running/
    num_dirs=$(find "/data/xnat/scripts/pipelines/running/" -type d | wc -l)
    while [ "$num_dirs" -gt 4 ]
    do
        sleep 30
        num_dirs=$(find "/data/xnat/scripts/pipelines/running/" -type d | wc -l)
    done
    mkdir /data/xnat/scripts/pipelines/running/${session_id}

    mkdir /data/xnat/cache/temp/${session_label}


    if  python3 /opt/scripts/process-rtstruct.py  "$session_id" "$session_label" "$project" ; then
       rm -R /data/xnat/scripts/pipelines/running/${session_id}
    else
        rm -R /data/xnat/scripts/pipelines/running/${session_id}
        exit 1
    fi
    
fi