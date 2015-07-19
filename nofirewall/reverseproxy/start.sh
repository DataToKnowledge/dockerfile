#!/usr/bin/env bash

spwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

baseDir="/data"
nginxDir="$baseDir/nginx"
confDir="$nginxDir/conf.d"
tmplDir="$nginxDir/templates"
stseDir="$nginxDir/sites-enabled"
crtsDir="$nginxDir/certs"
logsDir="$nginxDir/logs"
htmlDir="$nginxDir/html"

paths=($confDir $tmplDir $stseDir $crtsDir $logsDir $htmlDir)

if [ -d "$baseDir" ]; then
  for i in "${paths[@]}"
  do
    if [ ! -d "$i" ]; then
      mkdir -p $i
    fi
  done
  cp $spwd/templates/nginx.tmpl $tmplDir/nginx.tmpl
else
  echo "$baseDir not exists"
fi

# start nginx
docker run -dt -p 80:80 --name nginx \
  -v $confDir:/etc/nginx/conf.d \
  -v $stseDir:/etc/nginx/sites-enabled \
  -v $crtsDir:/etc/nginx/certs \
  -v $confDir:/etc/nginx/conf.d \
  -v $logsDir:/var/log/nginx \
  -v $htmlDir:/var/www/html \
  nginx

# start docker-gen
docker run --volumes-from nginx \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -v $tmplDir:/etc/docker-gen/templates \
  -t jwilder/docker-gen \
  -notify-sighup nginx -watch -only-exposed \
  /etc/docker-gen/templates/nginx.tmpl \
  /etc/nginx/conf.d/default.conf
