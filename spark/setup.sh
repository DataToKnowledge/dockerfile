#!/usr/bin/env bash

function sethostname {
    hn="$(hostname)"

    echo "    hostname: $hn.cloudapp.net" >> docker-compose.yml
}

function master {
    cp master.yml docker-compose.yml
    sethostname
}

function worker {
    cp worker.yml docker-compose.yml
    sethostname
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
