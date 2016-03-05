# Dockerfile

Used for production. To setup a private network on our cluster we use [weave.works](https://www.weave.works/).
Into each folder there is all that you need to start an image.

## Run DBPedia-Spotlight

default port 2230
```bash
docker run -d --name=dbpedia_it dbpedia/spotlight-italian spotlight.sh
```
