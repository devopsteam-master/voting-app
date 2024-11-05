#! /bin/sh

set -e
set -o pipefail

# مسیر فایل flag (استفاده از دایرکتوری خانگی کاربر)
FLAG_FILE="/root/restore_once_flag"

# بررسی وجود فایل flag
if [ -f "$FLAG_FILE" ]; then
  echo "The restore process has already been completed once. Exiting..."
  exit 0
fi

# ادامه اجرای اسکریپت ریستور
echo "Starting the restore process..."


if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${POSTGRES_DATABASE}" = "**None**" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ "${POSTGRES_HOST}" = "**None**" ]; then
  if [ -n "${POSTGRES_PORT}" ]; then
    POSTGRES_HOST=$POSTGRES_HOST
    POSTGRES_PORT=$POSTGRES_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ "${POSTGRES_USER}" = "**None**" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "**None**" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

if [ "${S3_ENDPOINT}" == "**None**" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi


# env vars needed for aws tools
mkdir -p ~/.aws
cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = $S3_ACCESS_KEY_ID
aws_secret_access_key = $S3_SECRET_ACCESS_KEY
EOL


export AWS_DEFAULT_REGION=$S3_REGION

export POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER"

if [ -z "$PASSPHRASE" ]; then
  file_type=".dump"
else
  file_type=".dump.gpg"
fi

echo "Finding latest backup"

LATEST_BACKUP=$(aws s3 ls s3://$S3_BUCKET/$S3_PREFIX/ $AWS_ARGS | sort | tail -n 1 | awk '{ print $4 }')


echo "Fetching ${LATEST_BACKUP} from S3"


aws $AWS_ARGS s3 cp s3://$S3_BUCKET/$S3_PREFIX/${LATEST_BACKUP} db$file_type
ls -lh

if [ -n "$PASSPHRASE" ]; then
  echo "Decrypting backup..."
  gpg --decrypt --batch --passphrase "$PASSPHRASE" db.dump.gpg > db.dump
  rm db.dump.gpg
fi


LOG_FILE="/tmp/restore.log"

if [ "${DROP_PUBLIC}" == "yes" ]; then
    echo "Dropping and recreating the public schema..."
    psql $POSTGRES_HOST_OPTS -d $POSTGRES_DATABASE -c "drop schema public cascade; create schema public;" | tee -a $LOG_FILE
fi

echo "Restoring ${LATEST_BACKUP}"


conn_opts="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DATABASE"

if pg_restore $conn_opts --clean --if-exists --verbose db.dump; then
  echo "Restore successful."
else
  echo "Restore failed."
  exit 1
fi

# ایجاد فایل flag پس از اجرای موفقیت‌آمیز اسکریپت
if touch "$FLAG_FILE"; then
  echo "Restore process completed. Flag file created at $FLAG_FILE. This script will not run again until the flag file is deleted."
else
  echo "Failed to create flag file. Please check permissions for the path $FLAG_FILE."
fi