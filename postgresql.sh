#!/bin/sh
# Stop on error
set -e

DATADIR=/data
chown -R postgres $DATADIR
mkdir -p /var/log/postgresql
chown -R postgres /var/log/postgresql
chmod 700 $DATADIR

exec /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres -c config-file=/etc/postgresql/9.3/main/postgresql.conf -c listen-addresses=* -c data_directory=$DATADIR
