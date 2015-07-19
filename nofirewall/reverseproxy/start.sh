#!/usr/bin/env bash

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

baseDir="/data"
nginxDir="$baseDir/nginx"
confDir="$nginxDir/conf.d"
tmplDir="$nginxDir/templates"

if [ -d "$baseDir" ]; then
  if [ ! -d "$confDir" ]; then
    mkdir -p $confDir
  fi
  if [ ! -d "$tmplDir" ]; then
    mkdir -p $tmplDir
    cp $spwd/templates/nginx.tmlp $tmplDir/nginx.tmlp
  fi
else
  echo "$baseDir not exists"
fi

# start nginx
docker run -dt -p 80:80 --name nginx \
  -v /tmp/nginx:/etc/nginx/conf.d \
  nginx

# start docker-gen
docker run --volumes-from nginx \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -v $tmplDir:/etc/docker-gen/templates \
  -t jwilder/docker-gen \
  -notify-sighup nginx -watch -only-exposed \
  /etc/docker-gen/templates/nginx.tmpl \
  /etc/nginx/conf.d/default.conf
