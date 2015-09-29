#!/bin/bash

# wait 10 seconds so that other machines can startup and register their names
sleep 20

/zookeeper/bin/zkServer.sh "$@"
