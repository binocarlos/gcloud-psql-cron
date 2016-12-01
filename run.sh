#!/bin/bash -e

set -e

function activate_gcloud() {
  gcloud auth activate-service-account ${SERVICE_ACCOUNT_EMAIL} \
  --key-file ${SERVICE_ACCOUNT_KEY_FILE} \
  --project ${SERVICE_ACCOUNT_PROJECT}
}

function run_cron() {
  devcron.py /cron/crontab
}

activate_gcloud
run_cron