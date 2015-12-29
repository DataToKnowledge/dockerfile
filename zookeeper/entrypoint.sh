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
autopurge.snapRetainCount=5
autopurge.purgeInterval=24
EOF

# server.1=...
if [ -n "$SERVERS" ]; then
    python -c "print '\n'.join(['server.%i=%s:2888:3888' % (i + 1, x) for i, x in enumerate('$SERVERS'.split(','))])" >> /opt/zookeeper/conf/zoo.cfg
fi

exec "$@"
