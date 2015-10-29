#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
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

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#if is passed the parameter -m then set master to true
master=false; [ "$1" == "-m" ] && master=true

#this cycle get the last argument passed to the script
#and save that in the $name variable, to use for naming the container
for last; do true; done
name=$last

#if $name is a number then change it in:
if [[ $name =~ ^-?[0-9]+$ ]]; then
  if [ $master == true ]; then #"spm-#" if is master node
    name="spm-$name"
  else
    name="spw-$name" #"spw-#" if is a worker node
  fi
fi

baseDir="/data"
sparkDir="$baseDir/spark"
dataDir="$sparkDir/data"
confDir="$sparkDir/config"
logsDir="$sparkDir/logs"

#an array that contains all the needed directories
paths=($confDir $dataDir $logsDir)

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  for i in "${paths[@]}"
  do
    if [ ! -d "$i" ]; then
      mkdir -p $i
    fi
  done
else #show an error message
  echo "$baseDir not exists"
fi

imgName="data2knowledge/spark:1.4.1"

cp -f $spwd/config/* $confDir/

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

if [ $master == true ]; then
  echo "spark.deploy.recoveryMode ZOOKEEPER" >> $confDir/spark-default.conf
  echo "spark.deploy.zookeeper.url zoo-1:2181,zoo-2:2181,zoo-3:2181" >> $confDir/spark-default.conf
  docker run --name $name --restart on-failure -d \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.master.Master -h $name
else
  docker run --name $name --restart on-failure -d \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.worker.Worker -h $name spark://spm-0:7077
fi
