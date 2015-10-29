#!/usr/bin/env bash

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

name=kafka-monitor

baseDir="/data"
kfmDir="$baseDir/kafkamonitor"
dataDir="$kfmDir/data"

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
      mkdir -p $dataDir
  fi
else #show an error message
  echo "$baseDir not exists"
fi

imgName="data2knowledge/kafkamonitor:0.2.1"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

docker run -d --name $name \
  -p 8080:8080
  -v $dataDir:/data \
  -e ZK="zoo-1,zoo-2,zoo-3" \
  $imgName
