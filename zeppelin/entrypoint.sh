#!/bin/sh

echo ${MYID:-1} > /data/myid

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
cat > /zeppelin/conf/zeppelin-env.sh <<EOF
# spark://spark-master-0:7077
export MASTER=${SPARK_MASTER}
EOF

exec "$@"
