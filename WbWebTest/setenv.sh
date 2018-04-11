#!/bin/bash

HOST_NAME=${HOST_NAME:-`curl http://169.254.169.254/latest/meta-data/instance-id`}
HOST_IP=${HOST_IP:-`curl http://169.254.169.254/latest/meta-data/local-ipv4`}

TOMCAT_LOG_PATH=/pang/logs/tomcat

source ${CATALINA_HOME}/bin/pinpoint.sh

export CATALINA_OPTS="$CATALINA_OPTS \
                        -server \
                        -Dspring.profiles.active="${SPRING_PROFILE}" \
                        -Dvitamin.log.home="${TOMCAT_LOG_PATH}"  \
                        "${JVM_MEMORY}" \
                        -Dcom.sun.management.jmxremote \
                        -Dcom.sun.management.jmxremote.port=11619 \
                        -Dcom.sun.management.jmxremote.ssl=false \
                        -Dcom.sun.management.jmxremote.authenticate=false \
                        -Djava.rmi.server.hostname="${HOST_IP}" \
                        "${CMDB_OPTS}" \
                        -Dcmdb.hostname="${HOST_NAME}" \
                        -Dcom.sun.management.jmxremote.rmi.port=11619 \
                        -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=8m -XX:+ParallelRefProcEnabled \
                        -XX:-ResizePLAB -XX:ParallelGCThreads=8 -XX:+UseThreadPriorities -XX:ThreadPriorityPolicy=42 \
                        -verbose:gc -Xloggc:${TOMCAT_LOG_PATH}/gc/gc.`date '+%Y%m%d%H%M'`.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps \
                        -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${TOMCAT_LOG_PATH}/heapdump_`date '+%Y%m%d%H%M'`.hprof \
"
