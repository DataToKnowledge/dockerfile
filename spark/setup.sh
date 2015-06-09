#!/usr/bin/env bash

function master {
    cp master.yml docker-compose.yml

    prefix='addr:'
    addr="$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')"
    addr=${addr#$prefix}

    echo "    hostname: spark-master.$addr.xip.io" >> docker-compose.yml
}

function worker {
    cp worker.yml docker-compose.yml
}

if [ $# -ne 1 ]; then
    echo "You need to type 'master' or 'worker' in order to configure this node"
    exit 1
else
    if [ "$1" = 'master' ]; then
        master
    elif [ "$1" = 'worker' ]; then
        worker
    else
        echo "Invalid argument, type 'master' or 'worker'"
    fi
fi
