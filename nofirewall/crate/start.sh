#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX|NAME

Example:
$: start 1      -- Creates a node named kfk-1
$: start node1  -- Creates a node named node1
EOF
    exit 1
fi

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

for last; do true; done
name=$last

if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="crt-$name"
fi

baseDir="/data"
crtDir="$baseDir/crate"
dataDir="$crtDir/data"
logsDir="$crtDir/logs"

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

imgName="crate:0.50.2.dtk"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -d \
  -v $dataDir:/data \
  $imgName crate -Des.network.publish_host=$name
