FROM java:8-jre

RUN apt-get update && \
    apt-get -y install curl

#SPARK
ENV SPARK_VERSION 1.4.1
ENV HADOOP_VERSION 2.6
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

RUN curl \
    --silent \
    http://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz \
    | gunzip \
    | tar x -C / && \
    mv /$SPARK_PACKAGE $SPARK_HOME

RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

EXPOSE 51001-51006

WORKDIR $SPARK_HOME

ENTRYPOINT ["/spark/bin/spark-class"]
