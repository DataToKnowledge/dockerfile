#!/usr/bin/env bash

# read the source dire
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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
  cp $script_dir/templates/nginx.tmpl $tmplDir/nginx.tmpl
else
  echo "$baseDir not exists"
fi

# start nginx
docker stop nginx &> /dev/null
docker rm nginx &> /dev/null
docker run -dt -p 80:80 --name nginx \
  -v $confDir:/etc/nginx/conf.d \
  -v $tmplDir:/etc/nginx/templates \
  -v $stseDir:/etc/nginx/sites-enabled \
  -v $crtsDir:/etc/nginx/certs \
  -v $logsDir:/etc/nginx/logs \
  -v $htmlDir:/var/www/html \
  -v $htpsDir:/etc/nginx/htpasswd \
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
  /etc/nginx/conf.d/default.conf
