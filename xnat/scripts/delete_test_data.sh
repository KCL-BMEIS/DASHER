source /data/xnat/home/xnat.cfg

curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE 'http://xnat-web2:8080/anon/data/projects/TEST'
curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE 'http://xnat-web1:8080/data/projects/QUARANTINE/subjects/uploader_S00001'
curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE "http://xnat-web2:8080/anon/data/projects/${anon_project}/subjects/uploader_anon_S00002"
curl -u $xnat_admin_user:$xnat_admin_pwd -X DELETE "http://xnat-web1:8080/data/projects/${hospital_code}/subjects/uploader_S00002"
