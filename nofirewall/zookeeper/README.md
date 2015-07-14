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
