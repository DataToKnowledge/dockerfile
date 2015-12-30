FROM java:8-jre

RUN apt-get update && \
    apt-get -y install curl

#SPARK
ENV SPARK_VERSION 1.5.2
ENV HADOOP_VERSION 2.6
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION
ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

RUN curl \
    http://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz \
    | gunzip \
    | tar x -C / && \
    mv /$SPARK_PACKAGE $SPARK_HOME

# add the hostname to the container
RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

WORKDIR $SPARK_HOME

COPY ./conf /spark/conf

EXPOSE 4040 6066 7077 8080 8081

ENTRYPOINT ["/spark/bin/spark-class"]
