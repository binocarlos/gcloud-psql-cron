#!/bin/bash -e

set -e

FILENAME=$(date +"%m-%d-%y-%T")
FILEPATH="/${FILENAME}.sql"

echo "creating ${FILEPATH}"
PGPASSWORD=${POSTGRES_SERVICE_PASSWORD} pg_dump -h ${POSTGRES_SERVICE_HOST} -U ${POSTGRES_SERVICE_USER} ${POSTGRES_SERVICE_DATABASE} > ${FILEPATH}

echo "compressing ${FILEPATH}"
gzip ${FILEPATH}

echo "uploading ${FILEPATH}.gz to gs://${SERVICE_ACCOUNT_STORAGE_BUCKET}"
gsutil cp ${FILEPATH}.gz gs://${SERVICE_ACCOUNT_STORAGE_BUCKET}