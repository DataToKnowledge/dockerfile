#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start INDEX

Example:
$: start 1
        -- Creates a node named chronograf-1
EOF
    exit 1
fi

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

id=$1

#if $name is a number then change it in "kafka-#"
if [[ $id == ^-?[0-9]+$ ]]; then
  echo "chronograf id must be a number"
  exit 1
fi

name="chronograf-$id"

imgName="data2knowledge/chronograf:0.10.3"

docker build -t $imgName $spwd
docker stop $name &> /dev/null
docker rm $name &> /dev/null
echo "starting chronograf with name ${name}"

docker run --name $name --restart=on-failure -dt \
  -p 10000:10000 \
  -e CHRONOGRAF_BIND=0.0.0.0:10000 \
  $imgName
