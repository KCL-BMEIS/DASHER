su - xnat -c "/opt/tomcat7/bin/shutdown.sh"
sleep 60
su - xnat -c "/opt/tomcat7/bin/catalina.sh run"
#tail -f /opt/tomcat7/logs/catalina.out 