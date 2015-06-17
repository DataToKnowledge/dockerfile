FROM java:7

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV KAFKA_RELEASE_ARCHIVE kafka_2.10-0.8.2.1.tgz

RUN mkdir /kafka /data /logs

RUN apt-get update && apt-get install -y ca-certificates

# Download Kafka binary distribution
ADD http://www.us.apache.org/dist/kafka/0.8.2.1/${KAFKA_RELEASE_ARCHIVE} /tmp/
ADD https://dist.apache.org/repos/dist/release/kafka/0.8.2.1/${KAFKA_RELEASE_ARCHIVE}.md5 /tmp/

WORKDIR /tmp

# Check artifact digest integrity
RUN echo VERIFY CHECKSUM: && \
  gpg --print-md MD5 ${KAFKA_RELEASE_ARCHIVE} 2>/dev/null && \
  cat ${KAFKA_RELEASE_ARCHIVE}.md5

# Install Kafka to /kafka
RUN tar -zx -C /kafka --strip-components=1 -f ${KAFKA_RELEASE_ARCHIVE} && \
  rm -rf kafka_*

ADD config /kafka/config
ADD start.sh /start.sh

ENV PATH /kafka/bin:$PATH
WORKDIR /kafka

# primary, jmx
EXPOSE 9092 7203
VOLUME [ "/data", "/logs" ]

CMD ["/start.sh"]
