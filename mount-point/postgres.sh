#! /bin/bash
set -e

echo 'hostssl all all all cert' > $PGDATA/pg_hba.conf