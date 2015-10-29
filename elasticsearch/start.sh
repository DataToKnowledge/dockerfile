#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start [OPTIONS] INDEX|NAME

Options:
  -m              If set indicates that is a master node

Example:
$: start -m 0     -- Creates a master node named esm-0
$: start node1    -- Creates a data node named node1
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#if is passed the parameter -m then set master to true and data to false,
#and vice versa if no -m parameter is passed
master=false; [ "$1" == "-m" ] && master=true
data=true; [ "$1" == "-m" ] && data=false

#this cycle get the last argument passed to the script
#and save that in the $name variable, to use for naming the container
for last; do true; done
name=$last

#if $name is a number then change it in:
if [[ $name =~ ^-?[0-9]+$ ]]; then
  if [ $master == true ]; then #"esm-#" if is master node
    name="esm-$name"
  else
    name="esd-$name" #"esd-#" if is data node
  fi
fi

baseDir="/data"
esDir="$baseDir/elasticsearch"
dataDir="$esDir/data"
logsDir="$esDir/logs"
configDir="$spwd/config"

#if $baseDir exists, then create the other subdirectories
if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    sudo chown pollinate:ssh $dataDir #change owner of the dir for es instance
  fi
  if [ ! -d "$logsDir" ]; then
    mkdir -p $logsDir
    sudo chown pollinate:ssh $logsDir #change owner of the dir for es instance
  fi
else #show an error message
  echo "$baseDir not exists"
fi

imgName="data2knowledge/elasticsearch:1.6.0"

#copy the template configuration file
cp -f $configDir/elasticsearch.yml.template $configDir/elasticsearch.yml

#set the node type, $master and $data can be true or false
echo "node.master: $master" >> $configDir/elasticsearch.yml
echo "node.data: $data" >> $configDir/elasticsearch.yml

#replace every {esn#} instance in config file with the actual node name
sed -i.bak s/{esn#}/$name/g $configDir/elasticsearch.yml

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
docker run --name $name --restart on-failure -d \
  -p 9200:9200 \
  -p 9300:9300 \
  -e ES_MIN_MEM=2g \
  -e ES_MAX_MEM=2g \
  -e ES_HEAP_SIZE=2g \
  -v $dataDir:/usr/share/elasticsearch/data \
  -v $logsDir:/usr/share/elasticsearch/logs \
  -v $configDir:/usr/share/elasticsearch/config \
  $imgName
