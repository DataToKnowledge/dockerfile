Nginx with Docker-gen
=====================

This docker can be used to start a reverse proxy with [nginx](http://nginx.org/en/) and [docker-gen](https://github.com/jwilder/docker-gen) as nginx configuration generator.

To setup the service run the script `./start.sh`. It needs as parameter a directory with the base templates for nginx. It will create all the need directories for ngins and setup the dockers. Please select carefully the base directory by copying the folder to another directory

Expose a container
==================

If we have an application named `myapp` just make a file named `myapp.conf` in `/data/nginx/conf.d` with this content:

```
upstream myapp.datatoknowledge.it {
  # elastic search
  server myapp-0:PORT;
  server myapp-1:PORT;
}

server {
  server_name myapp.datatoknowledge.it;
  location / {
    proxy_pass http://myapp.datatoknowledge.it;

    # Optional, only if the app need authentication.
    auth_basic    "Restricted myapp.datatoknowledge.it";
    auth_basic_user_file /etc/nginx/htpasswd/myapp;
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
