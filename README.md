# Postgresql server inside docker

Dockerfile with postgresql-9.3 server

## How to

This repository provides a postgresql-9.3 server. It is important to suply a volume for postgresql data. If the data dir is empty, when starting the container, it will create the database cluster, a user and a database. Creating a database might take a while (~ 5 seconds).

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

## Credits

This repository was inspired in the following repositories:

- [paintedfox/postgresql](https://index.docker.io/u/paintedfox/postgresql/)
- [orchardup/postgresql](https://index.docker.io/u/orchardup/postgresql/)
- [zumbrunnen/postgresql](https://index.docker.io/u/zumbrunnen/postgresql/)
- [ticosax/postgresql-in-docker](https://index.docker.io/u/ticosax/postgresql-in-docker/)
