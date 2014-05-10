# Postgresql server inside docker

Dockerfile with postgresql-9.3 server

## How to

This image provides a postgresql-9.3 server. It is important to suply a volume for postgresql data. If the data dir is empty, when starting the container, it will create the database cluster, a user and a database. Creating a database might take a while (~ 5 seconds).

When running check docker logs to see if the runit process (which starts postgresql database) has already started. 

### Build

```
docker build -t labianchin/postgresql .
```

### Run

```
docker run -i -t -v $(pwd)/volumes/data:/data -v $(pwd)/volumes/log:/var/log --name thesql -p 5432:5432 -d labianchin/postgresql

PG_PASSWORD=docker psql -h localhost -U docker docker
```

## TODO

- Add to docker index
- Improve documentation
- Improve postgresql configuration (maybe not using many RUN commands)
- Stress test, putting many data in the database
