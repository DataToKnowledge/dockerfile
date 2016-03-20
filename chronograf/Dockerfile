FROM debian:jessie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates apt-transport-https

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 684A14CF2582E0C5 && \
    echo "deb https://repos.influxdata.com/debian jessie stable" > /etc/apt/sources.list.d/influxdata.list && \
    apt-get update

ENV CHRONOGRAF_VERSION 0.10.0
RUN apt-get install -y chronograf=$CHRONOGRAF_VERSION

ENV CHRONOGRAF_BIND 0.0.0.0:10000

EXPOSE 10000

ENV PATH /opt/chronograf/:$PATH

ENTRYPOINT ["chronograf", "-config", "/opt/chronograf/config.toml"]