#!/bin/bash -e

set -e
set -x

PGPASSWORD=${POSTGRES_SERVICE_PASSWORD} \
    pg_dump -h ${POSTGRES_SERVICE_HOST} \
    -U ${POSTGRES_SERVICE_USER} ${POSTGRES_SERVICE_DATABASE} > backup.sql

HASH=$(sha1sum backup.sql | cut -f 1 -d ' ')

echo "Generated backup with SHA1: $HASH"

if gsutil ls gs://${SERVICE_ACCOUNT_STORAGE_BUCKET}/*${HASH}* ; then
    echo "Backup with same SHA1 already exists. Will not copy."
else
    echo "No existing backup with this SHA1. Copying."

    gzip -f backup.sql
    FILENAME=$(date +"%m-%d-%y-%T").${HASH}.sql.gz
    DEST=gs://${SERVICE_ACCOUNT_STORAGE_BUCKET}/$FILENAME

    echo "Uploading backup.sql.gz to $DEST"
    gsutil cp backup.sql.gz $DEST
    echo "Done"
fi
