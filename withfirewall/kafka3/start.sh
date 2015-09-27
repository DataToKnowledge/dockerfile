#!/bin/bash -x

export JMX_PORT=7203

for VAR in `env`
  do
    IFS="=" read -ra array <<< "$VAR"
    if grep -q "{{${array[0]}}}" /kafka/config/server.properties; then
      sed -i "s|{{${array[0]}}}|${array[1]}|g" /kafka/config/server.properties
    fi
  done

echo "Starting kafka"
exec /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
