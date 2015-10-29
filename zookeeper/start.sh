#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX|NAME

Example:
$: start 1      -- Creates a node named zoo-1
$: start node1  -- Creates a node named node1
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#this cycle get the last argument passed to the script
#and save that in the $name variable, to use for naming the container
for last; do true; done
name=$last

#if $name is a number then change it in "kafka-#"
if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="zoo-$name"
fi

baseDir="/data"
zooDir="$baseDir/zookeeper"
dataDir="$zooDir/data"
logsDir="$zooDir/logs"

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    echo $last > $dataDir/myid
  fi
  if [ ! -d "logsDir" ]; then
    mkdir -p $logsDir
  fi
else #show an error message
  echo "$baseDir not exists"
fi

imgName="data2knowledge/zookeeper:3.4.6"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -d \
  -p 2181:2181 \
  -p 2888:2888 \
  -p 3888:3888 \
  -v $dataDir:/data \
  -v $logsDir:/logs \
  -v $spwd/config:/zookeeper/conf \
  $imgName
