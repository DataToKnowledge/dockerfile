# Zookeeper
This docker can be used to start a zookeeper node.

I've created a convenient script to do this that takes in input one mandatory argument (the name or number of node to create).

## Examples
Cd to the directory where is the dockerfile.

Create a node named `zoo-#` with

```
$ ./start.sh #
```

You can either pass an explicit name

```
$ ./start.sh node_name
```

this will create a new node named `node_name`

## Known issues
It seems that ZooKeeper [doesn't retry DNS hostname->IP resolution if node connection fails](https://issues.apache.org/jira/browse/ZOOKEEPER-1506) and since we DNS entry for all ZooKeeper containers before starting them this is a problem.

As a workaround the entry point of this docker sleep for 10 seconds before start ZooKeeper node, in this time you should start all containers.
