FROM java:8-jre

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.8.2.1
ENV KAFKA_HOME /kafka
ENV KAFKA_PACKAGE kafka_$SCALA_VERSION-$KAFKA_VERSION

#install kafka
RUN curl \
    --silent \
    http://mirrors.muzzy.it/apache/kafka/$KAFKA_VERSION/$KAFKA_PACKAGE.tgz \
    | tar xzf - -C / && \
    mv /$ZOOKEEPER_PACKAGE $KAFKA_HOME && \
    rm -rf /$KAFKA_HOME/conf

COPY config $KAFKA_HOME/config

EXPOSE 9092 7203

VOLUME ["/data", "/logs"]

# used to fix weave IP issue
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/kafka/config/server.properties"]
