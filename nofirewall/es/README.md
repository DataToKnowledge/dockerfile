docker-elasticsearch
====================

This image can be used via:

-	docker-compose
-	docker

How to run with docker-compose
==============================

There is a `docker-compose.yml` to be used in development and a `production.yml` for production. Please refere to the [official documentation ](https://docs.docker.com/compose/extends/#example) for reference.

To start in development:

1.	`docker-compose up -d` start the service as daemon
2.	`docker-compose -f production.yml up -d ` to start with production yaml.

How to run with docker
======================

Build
-----

To build the images run

```
docker build -t="datatoknowledge/elasticsearch:1.5.2" ./
```

How to use this image
---------------------

You can run the default `elasticsearch` command simply:

```
docker run -d elasticsearch
```

You can also pass in additional flags to `elasticsearch`:

```
docker run -d elasticsearch elasticsearch -Des.node.name="TestNode"
```

This image comes with a default set of configuration files for `elasticsearch`, but if you want to provide your own set of configuration files, you can do so via a volume mounted at `/usr/share/elasticsearch/config`:

```
docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch
```

This image is configured with a volume at `/data` to hold the persisted index data. Use that path if you would like to keep the data in a mounted volume:

```
docker run -d -v "$PWD/esdata":/data elasticsearch
```

This image is configure with authentication in the folder `config\elasticsearch.yml`

```
http.basic.enabled: true
http.basic.user: "username"
http.basic.password: "password"
```

To connect to kopf using authentication we need that the index url should point to

```
http://user:password@localhost:9200/
```

How to use this image for production
====================================

Please follow this as checklist for running.

When the cluster is ran in production we should:

1.	check the `evnv_prod.list` for heap size
2.	check that there exists a folder like `/data/elasticsearch/dataX` where X is number of the instance ran
3.	setup the username and password as specified [our private config]()
