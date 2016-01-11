FROM java:8-jre

RUN apt-get update && \
    apt-get -y install curl

#SPARK
ENV SPARK_PACKAGE spark-1.6.0-Hadoop-2.7.1-scala-2.11
ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

RUN curl \
    https://www.dropbox.com/s/ahp5utc9hxvuryi/$SPARK_PACKAGE.tgz?dl=1 \
    | tar -xvzf && \
    mv /$SPARK_PACKAGE $SPARK_HOME

# add the hostname to the container
RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

WORKDIR $SPARK_HOME

COPY ./conf /spark/conf

EXPOSE 4040 6066 7077 8080 8081

ENTRYPOINT ["/spark/bin/spark-class"]
