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

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

master=false; [ "$1" == "-m" ] && master=true
data=true; [ "$1" == "-m" ] && data=false

for last; do true; done
name=$last

if [[ $name =~ ^-?[0-9]+$ ]]; then
  if [ $master == true ]; then
    name="esm$name"
  else
    name="esd$name"
  fi
fi

baseDir="/data"
esDir="$baseDir/elasticsearch"
dataDir="$esDir/data"
logsDir="$esDir/logs"

if [ -d "$baseDir" ]; then
  if [ ! -d "$dataDir" ]; then
    mkdir -p $dataDir
    sudo chown pollinate:ssh $dataDir
  fi
  if [ ! -d "logsDir" ]; then
    mkdir -p $logsDir
    sudo chown pollinate:ssh $logsDir
  fi
else
  echo "$baseDir not exists"
fi

imgName="elasticsearch:1.6.0.dtk"

cp -f $spwd/config/elasticsearch.yml.template $spwd/config/elasticsearch.yml

echo "node.master: $master" >> $spwd/config/elasticsearch.yml
echo "node.data: $data" >> $spwd/config/elasticsearch.yml

sed -i.bak s/{esn#}/$name/g $spwd/config/elasticsearch.yml

docker build -t $imgName .
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
  -v $(pwd)/config:/usr/share/elasticsearch/config \
  $imgName
