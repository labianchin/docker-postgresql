# BUILD-USING:		$ docker build -t labianchin/postgresql .
# RUN-USING:		$ docker run -it -v $(pwd)/volumes/data:/data -v $(pwd)/volumes/log:/var/log --name thesql -p 5432:5432 -d labianchin/postgresql
# DEBUG-USING:		$ docker run -it --rm labianchin/postgresql /bin/bash

FROM ubuntu:12:04

MAINTAINER Luis Bianchin <labianchin@l433.com>

#  Installs postgresql
RUN apt-get -q update
RUN apt-get -yqq install wget ca-certificates
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -q update &&\
    apt-get -qq install postgresql-9.3 postgresql-contrib-9.3 &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Cofigure the database to use data dir
# Postgresql configuration here, we might want to change something here
RUN sed -i -e"s/data_directory =.*$/data_directory = '\/data'/" /etc/postgresql/9.3/main/postgresql.conf && \
	echo "log_destination = 'stderr,syslog'" >> /etc/postgresql/9.3/main/postgresql.conf && \
	echo "syslog_facility = 'LOCAL0'" >> /etc/postgresql/9.3/main/postgresql.conf && \
	echo "syslog_ident = 'postgres'" >> /etc/postgresql/9.3/main/postgresql.conf && \
	echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf

ADD syslog-ng.postgresql.conf /etc/syslog-ng/conf.d/postgresql.conf

# Adds bootstrap script, to setup database cluster when /data is empty
ADD postgresql_bootstrap.sh /etc/my_init.d/
# Adds postgresql start script
ADD postgresql.sh /etc/service/postgresql/run
RUN chmod +x /etc/service/postgresql/run
RUN chmod +x /etc/my_init.d/postgresql_bootstrap.sh

# Decouple data from container
VOLUME ["/data", "/var/log/"]
EXPOSE 5432

CMD ["/sbin/my_init"]
