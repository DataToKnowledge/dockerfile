#!/usr/bin/env bash

case $1
  trifecta)
    docker run -dt -p 8888:8888 -e ZOOKEEPERS="zoo-1:2181,zoo-2:2181,zoo-3:2181" --name=trifecta chatu/trifecta
    ;;
  *)
    echo 'utils [trifecta | ]'
