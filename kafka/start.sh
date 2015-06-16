#!/bin/bash -x

export CLASSPATH=$CLASSPATH:/kafka/lib/slf4j-log4j12.jar
export JMX_PORT=7203

# If a ZooKeeper container is linked with the alias `zookeeper`, use it.
# TODO Service discovery otherwise
[ -n "$ZOOKEEPER_PORT_2181_TCP_ADDR" ] && ZOOKEEPER_IP=$ZOOKEEPER_PORT_2181_TCP_ADDR
[ -n "$ZOOKEEPER_PORT_2181_TCP_PORT" ] && ZOOKEEPER_PORT=$ZOOKEEPER_PORT_2181_TCP_PORT

cp -f /opt/kafka/config/server.properties.default /opt/kafka/config/server.properties

for VAR in `env`
  do
    IFS="=" read -ra array <<< "$VAR"
    if grep -q "{{${array[0]}}}" /opt/kafka/config/server.properties; then
      sed -i "s|{{${array[0]}}}|${array[1]}|g" /opt/kafka/config/server.properties
    fi
  done

echo "Starting kafka"
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
