#!/bin/bash

set -e

# define a custom elasticsearch.yml
echo "
network.host: 0.0.0.0
cluster.name: wheretolive
node.name: ${NAME}
bootstrap.mlockall: true

network.publish_host: _ethwe:ipv4_
discovery.zen.minimum_master_nodes: 3
discovery.zen.ping.timeout: 30s
discovery.zen.ping.unicast.hosts: [${UNICAST_HOSTS}]

discovery.zen.fd.ping_interval: 6s
discovery.zen.fd.ping_retries: 10" > /usr/share/elasticsearch/config/elasticsearch.yml

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
if [ "$1" = 'elasticsearch' ]; then
	# Change the ownership of /usr/share/elasticsearch/data to elasticsearch
	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
	exec gosu elasticsearch "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"
