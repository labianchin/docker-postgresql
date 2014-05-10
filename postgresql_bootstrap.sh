#!/bin/sh
set -e
set -x

DATADIR=/data
mkdir -p $DATADIR

if [ ! "$(ls -A $DATADIR)" ]; then
    USER=${USER:-docker}
    PASS=${PASS:-docker}
    DB=${DB:-docker}
    echo "POSTGRES_USER=$USER"
    echo "POSTGRES_PASS=$PASS"
    echo "POSTGRES_DB=$DB"
    echo "POSTGRES_DATA_DIR=$DATADIR"

    echo "Initializing postgresql database cluster at $DATADIR ..."

    # Copy database cluster to to the empty DATADIR
    cp -R /var/lib/postgresql/9.3/main/* $DATADIR
    
    # Ensure postgres owns DATADIR
    chown -R postgres $DATADIR
    # Ensure right permissions on DATADIR
    chmod -R 700 $DATADIR

    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE USER $USER WITH SUPERUSER PASSWORD '\''$PASS'\'';'"
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE DATABASE $DB OWNER $USER;'"
fi
