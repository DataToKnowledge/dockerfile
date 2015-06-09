FROM java:8-jre

RUN apt-get update && \
    apt-get -y install curl && \
    rm -rf /var/lib/apt/lists/*

#SPARK
ENV ZOOKEEPER_VERSION 3.4.6
ENV ZOOKEEPER_PACKAGE zookeeper-$ZOOKEEPER_VERSION
ENV ZOOKEEPER_HOME /zookeeper
ENV PATH $PATH:$ZOOKEEPER_HOME/bin

RUN curl \
    --silent \
    http://mirrors.muzzy.it/apache/zookeeper/$ZOOKEEPER_PACKAGE/$ZOOKEEPER_PACKAGE.tar.gz \
    | tar xzf - -C / && \
    mv /$ZOOKEEPER_PACKAGE $ZOOKEEPER_HOME && \
    rm -rf /$ZOOKEEPER_HOME/conf

WORKDIR $ZOOKEEPER_HOME
