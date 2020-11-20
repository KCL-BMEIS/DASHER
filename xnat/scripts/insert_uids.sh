#!/bin/bash
session_label=$1
project=$2


if [[ $project != *version*  ]]; then

    if  python3 /opt/scripts/insert_uids.py  "$session_label" "$project" ; then
       exit 0
    else
        
        exit 1
    fi
    
fi