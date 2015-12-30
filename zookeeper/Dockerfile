FROM java:8-jre

RUN apt-get update && \
apt-get install -y python

#zookeeper
ENV ZOOKEEPER_PACKAGE zookeeper-3.4.7

RUN curl -fL http://mirrors.muzzy.it/apache/zookeeper/$ZOOKEEPER_PACKAGE/$ZOOKEEPER_PACKAGE.tar.gz \
    | tar xzf - -C /opt && \
    mv /opt/$ZOOKEEPER_PACKAGE /opt/zookeeper

VOLUME ["/data", "/logs"]

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2181 2888 3888

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/zookeeper/bin

CMD ["zkServer.sh", "start-foreground"]
