#!/usr/bin/env bash

function clean {
    rm -f  ./docker-compose.yml
    rm -rf ./conf
}

function sethostname {
    hn="$(hostname).cloudapp.net"
    master="backend0.cloudapp.net"
    if [ "$1" = 'master' ]; then
        master=$hn
    fi

    printf "    hostname: $hn\n" >> ./docker-compose.yml

    printf "export SPARK_LOCAL_HOSTNAME=$hn\nexport SPARK_LOCAL_IP=$hn\nexport SPARK_PUBLIC_DNS=$hn\nexport SPARK_INTERNAL_HOSTNAME=$hn\nexport SPARK_EXTERNAL_HOSTNAME=$hn" >> ./conf/spark-env.sh

    printf "spark.master spark://$master:7077\nspark.driver.host $hn" >> ./conf/spark-defaults.conf

    if [ "$1" = 'master' ]; then
        printf "    command: /spark/bin/spark-class org.apache.spark.deploy.master.Master -h $hn" >> ./docker-compose.yml
    elif [ "$1" = 'worker' ]; then
        printf "    command: /spark/bin/spark-class org.apache.spark.deploy.worker.Worker -h $hn spark://backend0.cloudapp.net:7077" >> ./docker-compose.yml
    fi
}

function setup {
    clean
    cp ./$1.yml ./docker-compose.yml
    cp -r ./conf_$1 ./conf
    sethostname $1
}

if [ $# -ne 1 ]; then
    printf "\e[31mERROR:\e[0m You need to type -m or -w in order to configure this node"
    exit 1
else
    if [ "$1" = '-m' ]; then
        setup "master"
    elif [ "$1" = '-w' ]; then
        setup "worker"
    else
        printf "\e[31mERROR:\e[0m Invalid argument, type -m or -w"
    fi
fi
