#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX|NAME

Example:
$: start 1      -- Creates a node named kafka-1
$: start node1  -- Creates a node named node1
EOF
    exit 1
fi

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for last; do true; done
name=$last

if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="kafka-$name"
fi

baseDir="/data"
kafakaDir="$baseDir/kafka"
dataDir="$kafkaDir/data"
logsDir="$kafkaDir/logs"

if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    echo $last > $dataDir/myid
  fi
  if [ ! -d "logsDir" ]; then
    mkdir -p $logsDir
  fi
else
  echo "$baseDir not exists"
fi

cat $spwd/config/server.properties.template \
  | sed "s|{kfid}|$last|g" \
  | sed "s|{kfk#}|$name|g" \
   > $spwd/config/server.properties

imgName="data2knowledge/kafka:0.8.2.1"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -d \
  -p 9092:9092 \
  -p 7203:7203 \
  -v $dataDir:/data \
  -v $logsDir:/logs \
  -v $spwd/config:/kafka/conf \
  $imgName
