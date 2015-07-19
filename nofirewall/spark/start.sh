#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start [OPTIONS] INDEX|NAME

Options:
  -m              If set indicates that is a master node

Example:
$: start -m 0     -- Creates a master node named spm-0
$: start node1    -- Creates a data node named node1
EOF
    exit 1
fi

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

master=false; [ "$1" == "-m" ] && master=true
data=true; [ "$1" == "-m" ] && data=false

for last; do true; done
name=$last

if [[ $name =~ ^-?[0-9]+$ ]]; then
  if [ $master == true ]; then
    name="spm-$name"
  else
    name="spw-$name"
  fi
fi

baseDir="/data"
spDir="$baseDir/spark"
dataDir="$spDir/data"
confDir="$spDir/config"
logsDir="$spDir/logs"

paths=($confDir $dataDir $logsDir)

if [ -d "$baseDir" ]; then
  for i in "${paths[@]}"
  do
    if [ ! -d "$i" ]; then
      mkdir -p $i
    fi
  done
else
  echo "$baseDir not exists"
fi

imgName="spark:1.4.1.dtk"

cp -f $spwd/config/* $confDir/


docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

if [ $master == true ]; then
  echo "spark.deploy.recoveryMode ZOOKEEPER" >> $confDir/spark-default.conf
  echo "spark.deploy.zookeeper.url zoo-1:2181,zoo-2:2181,zoo-3:2181" >> $confDir/spark-default.conf
  docker run --name $name --restart on-failure -d \
    -p 4040:4040 \
    -p 6066:6066 \
    -p 7077:7077 \
    -p 8080:8080 \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.master.Master -h $name
else
  docker run --name $name --restart on-failure -d \
    -p 8081:8081 \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.worker.Worker -h $name spark://spm-0:7077
fi
