# Kafka
This docker can be used to start a kafka node.

I've created a convenient script to do this that takes in input one mandatory argument (the name or number of node to create).

## Examples
Cd to the directory where is the dockerfile.

Create a node named `kafka-#` with

```
$ ./start.sh <id> --zookeeper zoo-1.weave.local:2181,zoo-2.weave.local:2181,zoo-3.weave.local:2181
```
