export JAVA_HOME="/opt/jdk8/"
export PATH="$JAVA_HOME/bin:$PATH"
export CATALINA_OPTS="${CATALINA_OPTS} -Xms512m -Xmx1536m "
export CATALINA_OPTS="${CATALINA_OPTS} -Dxnat.home=/data/xnat/home"
export JAVA_OPTS="${JAVA_OPTS} -Xms512m -Xmx1536m -Djava.awt.headless=true -XX:+UseConcMarkSweepGC"
