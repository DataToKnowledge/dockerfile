#!/usr/bin/env bash

if [ "$#" -eq 0 ]; then
    cat << 'EOF'
You need to specify a name or a number for this elasticsearch node.

Example:
$: start 1
or
$: start node1
EOF
    exit 1
fi

name=$1

if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="es$name"
fi

baseDir="/data"
esDir="$baseDir/elasticsearch/wheretolive"
dataDir="$esDir/data"
logsDir="$esDir/logs"

if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    sudo chown pollinate:ssh $dataDir
  fi
  if [ ! -d "logsDir" ]; then
    mkdir -p $logsDir
    sudo chown pollinate:ssh $dataDir
  fi
else
  echo "$baseDir not exists"
fi

imgName="elasticsearch:1.6.0.dtk"

docker build -t $imgName .
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -h $name -P -d \
  -e ES_HEAP_SIZE=2g \
  -e ES_MIN_MEM=2g \
  -e ES_MAX_MEM=2g \
  -v $(pwd)/config:/usr/share/elasticsearch/config \
  -v $dataDir:/usr/share/elasticsearch/data \
  -v $logsDir:/usr/share/elasticsearch/logs \
  $imgName
