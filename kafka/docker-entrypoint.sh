#!/bin/bash

# empty hosts file
echo > /etc/hosts

/kafka/bin/kafka-server-start.sh "$@"
