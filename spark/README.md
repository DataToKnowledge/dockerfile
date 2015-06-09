# Spark Standalone Cluster

This image can be used via:

-	docker-compose

## How to run with docker-compose

There is no `docker-compose.yml` file but there are a `master.yml` and a `worker.yml`, that defines respectively a *master* service and a *worker* service, and a `setup.sh` script.

The `setup.sh` script accepts a single parameter that can be one of *master* or *worker*.

To start a node (i.e. master node) do the following:

```
$ cd /repo/root/directory
$ ./setup.sh master
$ docker-compose build && docker-compose up -d
```

The `setup.sh` script is necessary to correctly configure master hostname and to generate `docker-compose.yml`.
Indeed we need to use [xip.io](http://xip.io/) in order to resolve masters' hostname avoiding to install a DNS server so the script generates an adequate master's hostname. 

## TODO 
The services in this repo comes with the default configuration. We need to customize these to match our needs (i.e. setup ZooKeeper and use right ip addresses)
