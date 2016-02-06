#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start [OPTIONS] INDEX

Options:
  -m              If set indicates that is a master node

Example:
$: start -m 0     -- Creates a master node named es-master-0 [DEPRECATED]
$: start -d 0 -hosts es-data-0,es-data-1,es-data-2    -- Creates a data node named es-data-0 and unicast hosts es-data-0,es-data-1,es-data-2
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#if is passed the parameter -m then set master to true and data to false,
#and vice versa if no -m parameter is passed
master=false; [ "$1" == "-m" ] && master=true
data=true; [ "$1" == "-m" ] && data=false

# the second parameter holds the id
id=$2

#if $name is a number then change it in:
if [[ $id == ^-?[0-9]+$ ]]; then
  echo "the id should be numeric"
  exit 1
fi

if [ $master == true ]; then #"esm-#" if is master node
  name="es-master-$id"
else
  name="es-data-$id" #"esd-#" if is data node
fi

# unicast hosts
unicast_hosts=$4

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

imgName="data2knowledge/elasticsearch:2.1.1"

#copy the template configuration file
# cp -f $configDir/elasticsearch.yml.template $configDir/elasticsearch.yml

#set the node type, $master and $data can be true or false
# echo "node.master: $master" >> $configDir/elasticsearch.yml
# echo "node.data: $data" >> $configDir/elasticsearch.yml

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null

echo "starting ${name} ..."
docker run --name $name --restart on-failure -dt \
  -p 9200:9200 \
  -p 9300:9300 \
  -e ES_HEAP_SIZE=3g \
  -e NAME=$name \
  -e UNICAST_HOSTS=$unicast_hosts \
  -v $dataDir:/usr/share/elasticsearch/data \
  $imgName
