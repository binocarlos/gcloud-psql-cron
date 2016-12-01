# gcloud-psql-cron

Docker container uses cron and `psql` to do a database backup and then write the backup to object storage using the `gcloud` cli.

## usage

 * create a [service account](https://console.cloud.google.com/iam-admin/iam/project) that has a `Storage -> Storage Object Creator` role
 * download the `.json` key file and save it
 
You can now either:

 * add the key to a custom image `FROM binocarlos/gcloud-psql-cron`
 * mount the key as a Docker volume
 * use [k8s secrets](http://kubernetes.io/docs/user-guide/secrets/)

You end up with a file that contains the key.

To configure the container:

```bash
$ docker run
  -e SERVICE_ACCOUNT_EMAIL=... \
  -e SERVICE_ACCOUNT_KEY_FILE=/service-account-key.json \
  -v ./mykey.json:/service-account-key.json \
  binocarlos/gcloud-psql-cron
```

vars:

 * `SERVICE_ACCOUNT_EMAIL` - email associated with the [service account](https://console.cloud.google.com/iam-admin/iam/project)
 * `SERVICE_ACCOUNT_KEY_FILE` - path to the file containing the private key for the service account
 * `SERVICE_ACCOUNT_PROJECT` - gcloud project
 * `SERVICE_ACCOUNT_STORAGE_BUCKET` - the storage bucket to save the backups
 * `POSTGRES_SERVICE_HOST` - hostname for the postgres database
 * `POSTGRES_SERVICE_USER` - postgres user
 * `POSTGRES_SERVICE_PASSWORD` - postgres password
 * `POSTGRES_SERVICE_DATABASE` - postgres database

### crontab

You can control when the backup happens by adding a custom cronfile to `/cron/crontab` that points to the `/app/backup.sh` script.

Here is the default crontab that runs every hour:

```
0 * * * * /app/backup.sh
```

## license

MIT