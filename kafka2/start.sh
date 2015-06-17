#!/bin/bash -x

cat /kafka/config/server.properties \
  | sed "s|{{ZOOKEEPER_HOSTS}}|${ZOOKEEPER_HOSTS}|g" \
  | sed "s|{{HOSTNAME}}|${HOSTNAME}|g" \
  | sed "s|{{BROKER_ID}}|${BROKER_ID}|g" \
   > /kafka/config/server_instance.properties

export CLASSPATH=$CLASSPATH:/kafka/lib/slf4j-log4j12.jar
export JMX_PORT=7203

echo "Starting kafka"
exec /kafka/bin/kafka-server-start.sh /kafka/config/server_instance.properties
