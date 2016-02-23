#!/bin/sh

echo ${MYID:-1} > /data/myid

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
cat > /opt/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data
dataLogDir=/logs
clientPort=2181
# autopurge.snapRetainCount=5
# autopurge.purgeInterval=24
EOF

exec "$@"
