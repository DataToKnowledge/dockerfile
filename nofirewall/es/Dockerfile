FROM elasticsearch:1.6.0

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

# install the icu analyzer
RUN /usr/share/elasticsearch/bin/plugin --install elasticsearch/elasticsearch-analysis-icu/2.6.0

# install kopf manager
RUN  /usr/share/elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/master

VOLUME /usr/share/elasticsearch/logs
