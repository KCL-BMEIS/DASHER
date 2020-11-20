#!/bin/bash
url="http://xnat-web2:8080"
project=$1
subject_id=$2
session_label=$3
new_labels=$4


NOW=`date +'%Y%m%d'`


if [[ $project != *version*  ]]; then

    if [[ "$new_labels" != *","* ]]; then
	    echo "No labels to replace:  $project $subject_id $session_label newlabels:$new_labels" >> /data/xnat/scripts/logs/replace_rtstruct_labels_${NOW}.log
        exit 0
    fi
    if python3 /opt/scripts/replace_rtstruct_labels.py "$project" "$subject_id" "$session_label" "$new_labels" ; then
        echo "RTSTruct labels replaced"
        exit 0
    else
        exit 1
    fi
fi
    