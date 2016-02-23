# Dev environment

Like in [spotify-kafka](https://github.com/spotify/docker-kafka) the only configuration that we need to export for docker-machine envs are: kakfa-ip and zookeeper-ip

```bash
export KAFKA=`docker-machine ip \`docker-machine active\``:9092

export ZOOKEEPER=`docker-machine ip \`docker-machine active\``:2181
```

On the contrary for a native based docker environment you should export

```bash
export KAFKA=localhost:9092
```
