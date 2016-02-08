FROM elasticsearch:2.2.0

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

# install the icu analyzer
RUN plugin install analysis-icu

# install gui manager
RUN plugin install lmenezes/elasticsearch-kopf
# RUN plugin install jettro/elasticsearch-gui

# the data volume is already in the base dockerfile
VOLUME /usr/share/elasticsearch/data

ENV ES_HEAP_SIZE 1g

EXPOSE 9200 9300

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["elasticsearch"]
