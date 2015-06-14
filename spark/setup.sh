#!/usr/bin/env bash

function sethostname {
    hn="$(hostname).cloudapp.net"

    echo "    hostname: $hn" >> ./docker-compose.yml
    echo "export SPARK_PUBLIC_DNS=\"$hn\"" >> ./conf/spark-env.sh

    if [ "$1" = 'master' ]; then
        echo "spark.master spark://$hn:7077" >> ./conf/spark-defaults.conf
    fi
}

function master {
    cp ./master.yml ./docker-compose.yml
    cp -r ./conf_master ./conf
    sethostname "master"
}

function worker {
    cp ./worker.yml ./docker-compose.yml
    cp -r ./conf_worker ./conf
    sethostname
}

if [ $# -ne 1 ]; then
    echo "You need to type 'master' or 'worker' in order to configure this node"
    exit 1
else
    rm -f ./docker-compose.yml
    rm -rf ./conf
    if [ "$1" = 'master' ]; then
        master
    elif [ "$1" = 'worker' ]; then
        worker
    else
        echo "Invalid argument, type 'master' or 'worker'"
    fi
fi
