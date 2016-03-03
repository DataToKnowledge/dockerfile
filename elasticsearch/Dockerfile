FROM elasticsearch:2.2.0

MAINTAINER Datatoknowledge <info@datatoknowledge.it>

# install the icu analyzer
RUN plugin install analysis-icu

# install gui manager
RUN plugin install lmenezes/elasticsearch-kopf
# RUN plugin install jettro/elasticsearch-gui


# url analyzer https://github.com/jlinn/elasticsearch-analysis-url
# RUN plugin install https://github.com/jlinn/elasticsearch-analysis-url/releases/download/v2.1.1/elasticsearch-analysis-url-2.1.1.zip

# index attachments using tika
# bin/plugin install mapper-attachments

# the data volume is already in the base dockerfile
VOLUME /usr/share/elasticsearch/data

ENV ES_HEAP_SIZE 3g

EXPOSE 9200 9300

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["elasticsearch"]
