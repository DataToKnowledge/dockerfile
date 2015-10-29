#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX|NAME

Example:
$: start 1      -- Creates a node named kafka-1
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
  name="kafka-$name"
fi

baseDir="/data"
kafkaDir="$baseDir/kafka"
dataDir="$kafkaDir/data"
logsDir="$kafkaDir/logs"
configDir="$spwd/config"

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    echo $last > $dataDir/myid #creates a file used to identify this kafka instance
  fi
  if [ ! -d "$logsDir" ]; then
    mkdir -p $logsDir
  fi
else #show an error message
  echo "$baseDir not exists"
fi

#use a regex to replace {kfid} and {kfk#} from the template
#with the actual values
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
  -v $configDir:/kafka/conf \
  $imgName
