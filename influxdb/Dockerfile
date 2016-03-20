FROM debian:jessie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates apt-transport-https

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 684A14CF2582E0C5 && \
    echo "deb https://repos.influxdata.com/debian jessie stable" > /etc/apt/sources.list.d/influxdata.list && \
    apt-get update

ENV INFLUXDB_VERSION 0.10.3-1
RUN apt-get install -y influxdb=$INFLUXDB_VERSION

EXPOSE 8083 8086 8088 8091

VOLUME ["/var/lib/influxdb/data"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]