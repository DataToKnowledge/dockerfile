FROM java:8-jre

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV KAFKA_VERSION="0.8.1.1" SCALA_VERSION="2.10"

RUN mkdir /kafka /data /logs

#install kafka to /kafka
ADD download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar -xvf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /kafka/ --strip-components 1

ADD config /kafka/config
ADD start.sh /start.sh

ENV PATH /kafka/bin:$PATH
WORKDIR /kafka

# primary, jmx
EXPOSE 9092 7203

VOLUME [ "/data", "/logs" ]
CMD ["/start.sh"]
