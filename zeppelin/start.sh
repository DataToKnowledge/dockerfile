#!/usr/bin/env bash

#if no parameter is passed to the script, print the usage help
if [ "$#" -eq 0 ]; then
    cat << 'EOF'
Usage: start --spark-master <address>

Example:
$: ./start --spark-master spark://spark-master-0:7077
EOF
    exit 1
fi

if [ "$1" != "--spark-master" ]]; then
  echo "specify --spark-master <address>"
  exit 1
fi

spark_master=$2

#spwd holds the dirname of this script
spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

imgName="data2knowledge/zeppelin:0.6.0"
echo "buildng a zeppelin images with name $imgName"
docker build --rm=true -t $imgName $spwd


name="zeppelin"
docker stop $name &> /dev/null
docker rm $name &> /dev/null

echo "starting a zeppelin instance"
docker run --name $name --restart=on-failure -dt \
  -e SPARK_MASTER=$spark_master \
  -p 8080:8080 \
  $imgName
