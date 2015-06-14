FROM java:8-jre

RUN apt-get update && \
    apt-get -y install curl && \
    rm -rf /var/lib/apt/lists/*

#SPARK
ENV SPARK_VERSION 1.4.0
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-without-hadoop
ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

RUN curl \
    --silent \
    http://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz \
    | gunzip \
    | tar x -C / && \
    mv /$SPARK_PACKAGE $SPARK_HOME

WORKDIR $SPARK_HOME
