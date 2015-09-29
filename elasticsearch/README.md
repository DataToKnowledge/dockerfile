# Elasticsearch
This docker can be used to start either a master or data node.

I've created a convenient script to do this that takes in input one mandatory argument (the name or number of node to create) and an optional argument `-m` that indicates if this is a master node.

## Examples
Cd to the directory where is the dockerfile.

Create a master node named `esm-#` with

```
$ ./start.sh -m #
```

Create a data node named `esd-#` with

```
$ ./start.sh #
```

You can either pass an explicit name

```
$ ./start.sh node_name
```

this will create a new data node named `node_name`
