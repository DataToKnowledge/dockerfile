# Nginx with Docker-gen
This docker can be used to start a reverse proxy with [nginx](http://nginx.org/en/) and [docker-gen](https://github.com/jwilder/docker-gen) as nginx configuration generator.

I've created a convenient script to do this that takes no input.

Cd to the directory where is the dockerfile and simply run

```
$ ./start.sh
```

# Custom upstream
If we have an application named `myapp` just make a file named `myapp.conf` in `/data/nginx/conf.d` with this content:

```
upstream myapp.datatoknowledge.it {
  # elastic search
  server srv-0:PORT;
  server srv-1:PORT;
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
