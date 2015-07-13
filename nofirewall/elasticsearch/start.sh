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
baseDir="/data"
esDir="$baseDir/elasticsearch/{es#}"
dataDir="$esDir/data"
logsDir="$esDir/logs"

if [[ $name =~ ^-?[0-9]+$ ]]; then
  name="es$name"
fi

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

cp -f ./docker-compose.yml.template ./docker-compose.yml

echo "    - $dataDir:/usr/share/elasticsearch/data" >> ./docker-compose.yml
echo "    - $logsDir:/usr/share/elasticsearch/logs" >> ./docker-compose.yml

sed -i.bak s/{es#}/$name/g ./docker-compose.yml

#docker-compose up -d
