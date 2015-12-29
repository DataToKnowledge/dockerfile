#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX

Example:
$: ./start 1      -- Creates a node named zoo-1
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# the number of the istance
id=$1
#if $name is a number then change it in "kafka-#"
if [[ $id =~ ^-?[0-9]+$ ]]; then
  echo "error the id must be a number"
  exit 1
fi

$name="zoo-$id"

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

imgName="data2knowledge/zookeeper:3.4.7"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -dt \
  -e MYID=$id \
  -e SERVERS=zoo-1,zoo-2,zoo-3 \
  -p 2181:2181 \
  -p 2888:2888 \
  -p 3888:3888 \
  -v $dataDir:/data \
  -v $logsDir:/logs \
  $imgName
