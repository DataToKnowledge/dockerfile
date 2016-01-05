#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start [OPTIONS] INDEX|NAME

Options:
  --master             If set indicates that is a master node

Example:
$: start --master <name>: Creates a master node named spark-master-<id> [the names should be 0 or 1]
$: start --worker <name>: Creates a worker node named spark-worker-<id>
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#if is passed the parameter --master then set master to true
master=false; [ "$1" == "--master" ] && master=true

#the name of the node
name=$2

#if $name is a number then change it in:
if [[ $name =~ ^-?[0-9]+$ ]]; then
  if [ $master == true ]; then #"spark-master-#" if is master node
    name="spark-master-$name"
  else
    name="spark-worker-$name" #"spark-worker-#" if is a worker node
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

imgName="data2knowledge/spark:1.6.0"

cp -f $spwd/config/* $confDir/

#build the docker file in the spwd folder
docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

if [ $master == true ]; then
  echo "spark.deploy.recoveryMode ZOOKEEPER" >> $confDir/spark-default.conf
  echo "spark.deploy.zookeeper.url zoo-1:2181,zoo-2:2181,zoo-3:2181" >> $confDir/spark-default.conf
  docker run --name $name --restart on-failure -dt \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.master.Master -h $name
else
  docker run --name $name --restart on-failure -dt \
    -v $dataDir:/tmp/data \
    -v $logsDir:/logs \
    -v $confDir:/conf \
    $imgName \
    org.apache.spark.deploy.worker.Worker -h $name spark://spark-master-0:7077,spark-master-1:7077
fi
