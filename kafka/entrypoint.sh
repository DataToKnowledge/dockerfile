#!/bin/bash

# empty hosts file
# echo > /etc/hosts


# properties to add
echo "broker.id=${ID}
advertised.host.name=${NAME}
zookeeper.connect=${ZOOKEEPERS}" >> /opt/kafka/config/server.properties

echo " writing properties
broker.id=${ID}
advertised.host.name=${NAME}
zookeeper.connect=${ZOOKEEPERS}"

/opt/kafka/bin/kafka-server-start.sh "$@"
