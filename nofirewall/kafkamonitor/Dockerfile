FROM java:8-jre

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

ENV KAFKA_MONITOR_VERSION 0.2.1

RUN curl \
    --silent \
    -o app.jar \
    https://github.com/quantifind/KafkaOffsetMonitor/releases/download/v$KAFKA_MONITOR_VERSION/KafkaOffsetMonitor-assembly-$KAFKA_MONITOR_VERSION.jar

RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

ENV REFRESH 120.seconds
ENV RETAIN 2.days

EXPOSE 8080

WORKDIR /data

VOLUME ["/data"]

CMD exec java -cp /app.jar com.quantifind.kafka.offsetapp.OffsetGetterWeb --port 8080 --zk $ZK --refresh $REFRESH --retain $RETAIN
