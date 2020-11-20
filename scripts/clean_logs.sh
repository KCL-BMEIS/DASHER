
find /opt/tomcat7/temp/ -type f -mtime +10 -delete
cp -u /data/xnat/home/logs/access* /data/xnat/scripts/access_logs/
find /data/xnat/home/logs/  -type f -mtime +10 -delete
find /data/xnat/cache/    -type f -mtime +3  -delete
find /data/xnat/cache/*    -type d -mtime +3 | xargs rm -rf
find /data/xnat/build/ -type f -mtime +3 -delete
find /data/xnat/build/* -type d -mtime +3 | xargs rm -rf
find /data/xnat/anon/ -type f -mtime +3 -delete
find /data/xnat/anon/* -type d -mtime +3 | xargs rm -rf


#find /data/xnat/archive/ -name "*.dcm" -type f -mtime +30 -delete
#find /data/xnat/archive/ -name "*.nii" -type f -mtime +30 -delete
#find /data/xnat/archive/ -name "*.bf" -type f  -mtime +30 -delete

