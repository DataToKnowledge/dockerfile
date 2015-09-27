#!/usr/bin/env bash

# read the base dir as parameter
base_pwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# create the directory needed for the container
baseDir="/data"
nginxDir="$baseDir/nginx"
confDir="$nginxDir/conf.d"
tmplDir="$nginxDir/templates"
stseDir="$nginxDir/sites-enabled"
crtsDir="$nginxDir/certs"
logsDir="$nginxDir/logs"
htmlDir="$nginxDir/html"
htpsDir="$nginxDir/htpasswd"

paths=($confDir $tmplDir $stseDir $crtsDir $logsDir $htmlDir $htpsDir)

# create the directories
if [ -d "$baseDir" ]; then
  for i in "${paths[@]}"
  do
    if [ ! -d "$i" ]; then
      mkdir -p $i
    fi
  done
  cp $base_pwd/templates/nginx.tmpl $tmplDir/nginx.tmpl
else
  echo "$baseDir not exists"
fi

# start nginx
docker stop nginx &> /dev/null
docker rm nginx &> /dev/null
docker run -dt -p 80:80 --name nginx \
  -v $stseDir:/etc/nginx/sites-enabled \
  -v $htpsDir:/etc/nginx/htpasswd \
  -v $confDir:/etc/nginx/conf.d \
  -v $confDir:/etc/nginx/conf.d \
  -v $crtsDir:/etc/nginx/certs \
  -v $logsDir:/var/log/nginx \
  -v $htmlDir:/var/www/html \
  nginx

# start docker-gen
docker stop docker-gen &> /dev/null
docker rm docker-gen &> /dev/null
docker run --volumes-from nginx --name docker-gen \
  -v /var/run/docker.sock:/tmp/docker.sock:ro \
  -v $tmplDir:/etc/docker-gen/templates \
  -dt jwilder/docker-gen \
  -notify-sighup nginx -watch -only-exposed \
  /etc/docker-gen/templates/nginx.tmpl \
  /etc/docker-gen/templates/fluentd.conf.tmpl \
  /etc/docker-gen/templates/logrotate.tmpl \
  /etc/nginx/conf.d/default.conf
