#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX|NAME

Example:
$: start 1      -- Creates a node named zoo-1
$: start node1  -- Creates a node named node1
EOF
    exit 1
fi

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for last; do true; done
name=$last

if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="zoo-$name"
fi

baseDir="/data"
zooDir="$baseDir/zookeeper"
dataDir="$zooDir/data"
logsDir="$zooDir/logs"

if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
  fi
  if [ ! -d "logsDir" ]; then
    mkdir -p $logsDir
  fi
else
  echo "$baseDir not exists"
fi

imgName="zookeeper:3.4.6.dtk"

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
