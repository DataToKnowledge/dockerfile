# No Firewall Dockerfile
Here are `dockerfile`s for all the containers created specifically to work within the same network (azure virtual network or weave network).

## Weave network issue
When starting a container either with `docker` or `weave` it will have two IP addresses: one assigned by Docker and one assigned through Weave. So `hostname -I` will return something like:

```
$ hostname -I
172.17.42.1 192.168.0.83
```

however, `hostname -i` returns the Docker-assigned IP address:

```
$ hostname -i
172.17.42.1
```

This breaks our containers like ZooKeeper and ElasticSearch that bound themselves on Docker-assigned IP address so they will refuse every inbound connection that use weave IP address as target.

This is a known issue ( [#68](https://github.com/weaveworks/weave/issues/68), [#1079](https://github.com/weaveworks/weave/pull/1079), [#1122](https://github.com/weaveworks/weave/issues/1122) )

A workaround is to empty `/etc/hosts` file with

```
$ sudo echo > /etc/hosts
```

when the container starts.

We probably need a `docker-entrypoint.sh` that do this like the one in [ZooKeeper dockerfile](zookeeper/docker-entrypoint.sh)
