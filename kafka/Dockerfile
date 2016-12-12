FROM java:8-jre

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.9.0.1
ENV KAFKA_HOME /opt/kafka
ENV KAFKA_PACKAGE kafka_$SCALA_VERSION-$KAFKA_VERSION

#install kafka
RUN curl \
    http://it.apache.contactlab.it/kafka/$KAFKA_VERSION/$KAFKA_PACKAGE.tgz \
    | tar xzf - -C /opt && \
    mv /opt/$KAFKA_PACKAGE $KAFKA_HOME

    # && \
    # rm -rf /$KAFKA_HOME/config

COPY config/ $KAFKA_HOME/config/

EXPOSE 9092 7203

VOLUME ["/data", "/logs"]

# used to fix weave IP issue
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/kafka/bin

CMD ["/opt/kafka/config/server.properties"]
