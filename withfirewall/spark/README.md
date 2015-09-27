# Spark Standalone Cluster

This image can be used via:

-	docker-compose
-	docker

## Docker Compose

The most straightforward way is to use docker-compose. This repo comes with a `setup.sh` script that generates the `docker-compose.yml` starting from one of the two `.yml` files in the root directory (`master.yml` and `worker.yml`).

To generate a master|worker `docker-compose.yml` file simply type

```
$ cd /root/repo/directory
$ ./setup.sh master|worker
```

then use `docker-compose` to build and run the image with

```
$ docker-compose build && docker-compose up -d
```

Example (start a master node):

```
$ cd /root/repo/directory
$ ./setup.sh master
$ docker-compose build && docker-compose up -d
```

## Docker

### Build

```
$ cd /root/repo/directory
$ docker build -t="datatoknowledge/spark:1.3.1" ./
```
### Run the image
//TODO

## Configuration 
This repo uses the default configuration for master nodes and set 4Gb of memory for worker nodes. In the `config` directory there are master and worker configuration. The default master url is `backend0.cloudapp.net`, it can be changed modifying `worker.yml` command.
