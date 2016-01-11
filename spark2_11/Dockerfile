FROM java:8-jre

RUN apt-get update && \
    apt-get -y install wget

#SPARK
ENV SPARK_PACKAGE spark-1.6.0-SNAPSHOT-bin-2.7.1
ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

RUN wget \
    https://www.dropbox.com/s/bhfyxuqycgtra45/${SPARK_PACKAGE}.tgz?dl=1 -O ${SPARK_PACKAGE}.tgz  && \
    tar -xvzf ${SPARK_PACKAGE}.tgz && \
    mv /$SPARK_PACKAGE $SPARK_HOME

# add the hostname to the container
RUN sed 's/^\(hosts:[\ ]*\)\(files\)\ \(dns\)$/\1\3 \2/' -i /etc/nsswitch.conf

WORKDIR $SPARK_HOME

COPY ./conf /spark/conf

EXPOSE 4040 6066 7077 8080 8081

ENTRYPOINT ["/spark/bin/spark-class"]
