Apache Kafka on Docker
======================

This repository holds a build definition and supporting files for building a[Docker](http://www.docker.io) image to run [Kafka](http://kafka.apache.org) in containers.

Usage Quick Start
-----------------

Here is a minimal-configuration example running the Kafka broker service.

At first edit the file `development.env.default` or the file "production.env.default" renaming the file removing the .default suffix . Specify values for:

```
ZOOKEEPER_IP=<IP>
ZOOKEEPER_PORT=2181
BROKER_ID=<ID>
CHROOT=/v0_8_2
EXPOSED_HOST=<IP>
PORT=9092
EXPOSED_PORT=9092
```

```
$ docker-compose build

# in dev mode
$ docker-compose up -d

# in production mode
$ docker-compose --file docker-production.yml up -d

```

Then using the container as a client to run the basic producer and consumer example from [the Kafka Quick Start](http://kafka.apache.org/documentation.html#quickstart):

```
$ docker run --rm kafka2_kafka1 \
kafka-topics.sh --create --topic test \
--replication-factor 1 --partitions 2 --zookeeper $ZOOKEEPER_NODES

$ docker run --rm kafka2_kafka1 \
kafka-topics.sh --describe --zookeeper $ZOOKEEPER_NODES

$ docker run --rm -i kafka2_kafka \
kafka-console-producer.sh --topic test --broker-list $KAFKA_HOSTNAME:9092

# from anothe terminal
$ docker run --rm kafk2a_kafka \
kafka-console-consumer.sh --topic test --from-beginning --zookeeper $ZOOKEEPER_NODES

```

### Volumes

The container exposes two volumes that you may wish to bind-mount, or process elsewhere with `--volumes-from`:

-	`/data`: Path where Kafka's data is stored (`log.dirs` in Kafka configuration)
-	`/logs`: Path where Kafka's logs (`INFO` level) will be written, via log4j

### Ports and Linking

The container publishes two ports:

-	`9092`: Kafka's standard broker communication
-	`7203`: JMX publishing, for e.g. jconsole or VisualVM connection

Kafka requires Apache ZooKeeper. You can satisfy the dependency by simply linking another container that exposes ZooKeeper on its standard port of 2181, as shown in the above example, **ensuring** that you link using an alias of`zookeeper`.

Alternatively, you may configure a specific address for Kafka to find ZK. See the Configuration section below.

Configuration
-------------

Some parameters of Kafka configuration can be set through environment variables when running the container (`docker run -e VAR=value`). These are shown here with their default values, if any:

-	`BROKER_ID=0`

Maps to Kafka's `broker.id` setting. Must be a unique integer for each broker in a cluster. - `PORT=9092`

Maps to Kafka's `port` setting. The port that the broker service listens on. You will need to explicitly publish a new port from container instances if you change this. - `EXPOSED_HOST=<container's IP within docker0's subnet>`

Maps to Kafka's `advertised.host.name` setting. Kafka brokers gossip the list of brokers in the cluster to relieve producers from depending on a ZooKeeper library. This setting should reflect the address at which producers can reach the broker on the network, i.e. if you build a cluster consisting of multiple physical Docker hosts, you will need to set this to the hostname of the Docker *host's* interface where you forward the container `PORT`. - `EXPOSED_PORT=9092`

As above, for the port part of the advertised address. Maps to Kafka's `advertised.port` setting. If you run multiple broker containers on a single Docker host and need them to be accessible externally, this should be set to the port that you forward to on the Docker host. - `ZOOKEEPER_IP=<taken from linked "zookeeper" container, if available>`

**Required** if no container is linked with the alias "zookeeper" and publishing port 2181. Used in constructing Kafka's `zookeeper.connect` setting. - `ZOOKEEPER_PORT=2181`

Used in constructing Kafka's `zookeeper.connect` setting. - `CHROOT`, ex: `/v0_8_1`

ZooKeeper root path used in constructing Kafka's `zookeeper.connect` setting. This is blank by default, which means Kafka will use the ZK `/`. You should set this if the ZK instance/cluster is shared by other services, or to accommodate Kafka upgrades that change schema. However, as of 0.8.1.1 Kafka will *not* create the path in ZK automatically, you must ensure it exists before starting brokers.

This is based on https://github.com/ches/docker-kafka
