#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX

Example:
$: start 1
        -- Creates a node named influxdb-1
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

id=$1

#if $name is a number then change it in "kafka-#"
if [[ $id == ^-?[0-9]+$ ]]; then
  echo "influxdb id must be a number"
  exit 1
fi

name="influxdb-$id"
baseDir="/data"
influxdbDir="$baseDir/influxdb"

mkdir -p $influxdbDir/data


imgName="data2knowledge/influxdb:0.10.3"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
echo "starting influxdb with name ${name}"

docker run --name $name --restart=on-failure -dt \
  -p 8083:8083 \
  -p 8086:8086 \
  -v $influxdbDir:/var/lib/influxdb/data \
  $imgName
