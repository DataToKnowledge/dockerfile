Nginx with Docker-gen
=====================

This docker can be used to start a reverse proxy with [nginx](http://nginx.org/en/) and [docker-gen](https://github.com/jwilder/docker-gen) as nginx configuration generator.

To setup the service run the script `./start.sh`. By default the docker is installed in the directory `data/nginx`.

Expose a container
==================

If we have an application named `myapp` just make a file named `myapp.conf` in `/data/nginx/conf.d` with this content:

```
upstream name-app.datatoknowledge.it {
                   # name-app
                   server name-app:5000;
}

server {
        gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

        server_name name-app.datatoknowledge.it;
        proxy_buffering off;
        error_log /proc/self/fd/2;
        access_log /proc/self/fd/1;

        location / {
                proxy_pass http://name-app.datatoknowledge.it;
                proxy_set_header Host $http_host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;

                # HTTP 1.1 support
                proxy_http_version 1.1;
                proxy_set_header Connection "";

                # Optional, only if the app need authentication.
                auth_basic    "Restricted name-app.datatoknowledge.it";
                auth_basic_user_file /etc/nginx/htpasswd/name-app;
        }
}
```

If `myapp` needs authentication create a file named `myapp` in `/data/nginx/htpasswd` using [htpasswd](http://httpd.apache.org/docs/2.2/programs/htpasswd.html) with:

```
$ htpasswd -c myapp username
```

If no command `htpasswd` is found then you need to install `apache2-utils` with:

```
$ sudo apt-get install apache2-utils
```

After added a custom upstream you can greacefully restart nginx with

```
docker kill -s HUP nginx
```

or using the script [reloadconfig.sh](reloadconfig.sh)
