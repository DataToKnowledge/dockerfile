#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX ZOOKEEPERS

Example:
$: start 1 --zookeeper zoo-1:2181,zoo-2:2181,zoo-3:2181
        -- Creates a node named kafka-1 connected to zoo-1:2181,zoo-2:2181,zoo-3:2181
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

id=$1

#if $name is a number then change it in "kafka-#"
if [[ $id == ^-?[0-9]+$ ]]; then
  echo "kafka id must be a number"
  exit 1
fi

# the third argument should be the zookeepers addresses
zookeeper=${3-"zoo-1:2181,zoo-2:2181,zoo-3:2181"}

name="kafka-$id"
baseDir="/data"
kafkaDir="$baseDir/kafka"
dataDir="$kafkaDir/data"
logsDir="$kafkaDir/logs"

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    echo $id > $dataDir/myid #creates a file used to identify this kafka instance
  fi
  if [ ! -d "$logsDir" ]; then
    mkdir -p $logsDir
  fi
else #show an error message
  echo "$baseDir not exists"
fi

#use a regex to replace {kfid} and {kfk#} from the template
#with the actual values
# cat $spwd/config/server.properties.template \
#   | sed "s|{kfid}|$id|g" \
#   | sed "s|{kfk#}|$name|g" \
#    > $spwd/config/server.properties

imgName="data2knowledge/kafka:0.9.0.0"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
echo "starting kafka with name ${name}"

docker run --name $name --restart=on-failure -dt \
  -e ID=$id \
  -e NAME=$name \
  -e ZOOKEEPERS=$zookeeper \
  -p 9092:9092 \
  -p 7203:7203 \
  -v $dataDir:/data \
  -v $logsDir:/logs \
  $imgName
