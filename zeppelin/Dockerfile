FROM maven:3.3.3-jdk-7
MAINTAINER Fabio Fumarola <fabiofumarola@gmail.com>

RUN  \
  export DEBIAN_FRONTEND=noninteractive && \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y git npm

RUN git clone https://github.com/felixcheung/incubator-zeppelin.git /zeppelin

WORKDIR /zeppelin
RUN git checkout spark16
#-Dscala-2.11 
RUN mvn clean package -Pspark-1.6 -Dhadoop.version=2.6.0 -Phadoop-2.6 -Ppyspark -DskipTests

EXPOSE 8080

COPY entrypoint.sh /zeppelin

ENTRYPOINT ["/zeppelin/entrypoint.sh"]

CMD ["bin/zeppelin.sh", "start"]
