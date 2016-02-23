#!/bin/bash

# empty hosts file
# echo > /etc/hosts


# properties to add
echo "broker.id=0
advertised.host.name=${NAME}
zookeeper.connect=${ZOOKEEPERS}
auto.create.topics.enable=true
log.cleaner.enable=true
" >> /opt/kafka/config/server.properties

echo " writing properties
broker.id=${ID}
advertised.host.name=${NAME}
zookeeper.connect=${ZOOKEEPERS}"

/opt/kafka/bin/kafka-server-start.sh "$@"
