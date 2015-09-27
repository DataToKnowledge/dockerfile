FROM java:8-jre

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.11"

RUN mkdir /opt/kafka /data /logs

#install kafka to /opt/kafka
ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar -xvf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt/kafka/ --strip-components 1
ENV KAFKA_HOME /opt/kafka

# RUN wget http://repo1.maven.org/maven2/org/slf4j/slf4j-log4j12/1.7.6/slf4j-log4j12-1.7.6.jar \
#   -P /opt/kafka/libs/

RUN rm -rf /opt/kafka/config
COPY config /opt/kafka/config
ADD start.sh /start.sh

# Set up a user to run Kafka
RUN groupadd kafka && \
  useradd -d /opt/kafka -g kafka -s /bin/false kafka && \
  chown -R kafka:kafka /opt/kafka /data /logs

USER kafka
ENV PATH /opt/kafka/bin:$PATH

# primary, jmx
EXPOSE 9092 7203


VOLUME ["/data","opt/kafka/config", "/logs"]

CMD ["/start.sh"]
