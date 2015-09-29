#!/usr/bin/env bash

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

name=kfkmntr

baseDir="/data"
kfmDir="$baseDir/kafkamonitor"
dataDir="$kfmDir/data"

if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
      mkdir -p $dataDir
  fi
else
  echo "$baseDir not exists"
fi

imgName="data2knowledge/kafkamonitor:0.2.1"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

docker run -d --name $name \
  -v $dataDir:/data \
  -e ZK="zoo-1,zoo-2,zoo-3" \
  $imgName
