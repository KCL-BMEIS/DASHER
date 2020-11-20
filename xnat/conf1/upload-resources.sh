source /data/xnat/home/xnat.cfg

#upload clinical trial labels...
dos2unix /data/xnat/scripts/clinical_trials/*
#FILES=/data/xnat/scripts/clinical_trials/*labels.txt

FILES="/data/xnat/archive/$hospital_code/resources/clinical_trials/*required_labels.txt"
#existing_files="/data/xnat/archive/$hospital_code/resources/clinical_trials/clinical_trial_names.txt"
trials=""
rm /data/xnat/trials.txt
for f in $FILES
do
    b=$(basename $f)
    trial="${b/_required_labels.txt/}"
    echo $trial >> /data/xnat/trials.txt
    echo 'Found resource file '"$f"'  Adding trial  '"$trial"'   ' 
done
curl -u  $xnat_admin_user:$xnat_admin_pwd  -X PUT 'http://localhost:8080/data/archive/projects/'"$hospital_code"'/resources/clinical_trials/files/clinical_trial_names.txt?overwrite=true' -F "filename=@/data/xnat/trials.txt"




PROJECTS=$(curl -u  $xnat_admin_user:$xnat_admin_pwd  -X GET 'http://xnat-web2:8080/anon/data/archive/projects?format=csv')

echo "$PROJECTS" > /data/xnat/anon_projects.csv
b="anon_projects.csv"
f="/data/xnat/anon_projects.csv"
curl -u  $xnat_admin_user:$xnat_admin_pwd  -X PUT 'http://localhost:8080/data/archive/projects/'"$hospital_code"'/resources/anonymised_projects/files/'"$b"'?overwrite=true' -F "filename=@$f"

