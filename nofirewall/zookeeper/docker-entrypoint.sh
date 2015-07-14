#!/bin/bash

# empty hosts file
echo > /etc/hosts

# wait 10 seconds so that other machines can startup and register theri names
sleep 10

/zookeeper/bin/zkServer.sh "$@"
