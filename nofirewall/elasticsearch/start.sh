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

echo $name

cp -f ./docker-compose.yml.template ./docker-compose.yml
sed -i.bak s/{es#}/$name/g ./docker-compose.yml

#docker-compose up -d
