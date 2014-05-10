# BUILD-USING:		$ docker build -t labianchin/postgresql .
# RUN-USING:		$ docker run -i -t -v $(pwd)/volumes/data:/data -v $(pwd)/volumes/log:/var/log --name thesql -p 5432:5432 -d labianchin/postgresql
# DEBUG-USING:		$ docker run -i -t -v $(pwd)/volumes/data:/data -v $(pwd)/volumes/log:/var/log --name thesql -p 5432:5432 --rm labianchin/postgresql /bin/bash

FROM phusion/baseimage:0.9.9

MAINTAINER Luis Bianchin <labianchin@l433.com>

#  Installs postgresql
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install postgresql-9.3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo -n en_US.UTF-8 > /etc/container_environment/LANG

# Cofigure the database to use data dir
RUN sed -i -e"s/data_directory =.*$/data_directory = '\/data'/" /etc/postgresql/9.3/main/postgresql.conf
# Postgresql configuration here, we might want to change something here
RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "log_destination = 'stderr,syslog'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "syslog_facility = 'LOCAL0'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "syslog_ident = 'postgres'" >> /etc/postgresql/9.3/main/postgresql.conf

ADD syslog-ng.postgresql.conf /etc/syslog-ng/conf.d/postgresql.conf

# Decouple data from container
VOLUME ["/data", "/var/log/"]

EXPOSE 5432

ADD postgresql_bootstrap.sh /etc/my_init.d/
ADD postgresql.sh /etc/service/postgresql/run
RUN chmod +x /etc/service/postgresql/run /etc/my_init.d/postgresql_bootstrap.sh

CMD ["/sbin/my_init"]
