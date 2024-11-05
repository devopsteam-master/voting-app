# Backup Service Deployment Guide

This backup service is designed to automatically back up a PostgreSQL database to MinIO using a schedule. It securely connects to both PostgreSQL and MinIO, storing compressed database backups in MinIO’s object storage with a customizable retention period.

The following guide will walk you through setting up, deploying, and understanding the backup service.

---

## Table of Contents

1. [Overview](#overview)
2. [Environment Variables](#environment-variables)
3. [Project Structure](#project-structure)
4. [Deployment Steps](#deployment-steps)
5. [Service Configuration](#service-configuration)
6. [Scheduling and Retention](#scheduling-and-retention)
7. [Troubleshooting](#troubleshooting)

---

## Overview

This backup service uses a Docker container to:

1. Periodically back up a PostgreSQL database.
2. Store the backups securely in MinIO, a self-hosted S3-compatible storage solution.
3. Retain backups for a specified period, automatically deleting older backups.

This service is particularly useful for data recovery and disaster preparedness. It operates independently of the main application, ensuring that backup processes do not affect primary workflows.

---

## Environment Variables

To configure the backup service, create a `.env` file in the root directory with the following variables:

```plaintext
# MinIO Configuration
S3_ENDPOINT="http://minio:9000"         # MinIO endpoint URL
S3_BUCKET=back-up                       # Target bucket in MinIO for storing backups
S3_PREFIX=backup                        # Folder within the bucket
S3_REGION=region                        # Region (placeholder, can be arbitrary)
S3_ACCESS_KEY_ID=AccessKeyID            # Access key for MinIO
S3_SECRET_ACCESS_KEY=SecretKeyID        # Secret key for MinIO

# PostgreSQL Configuration
POSTGRES_PORT="5432"                    # PostgreSQL port
POSTGRES_HOST=db                        # Hostname for the PostgreSQL instance
POSTGRES_USER=postgres                  # PostgreSQL username
POSTGRES_PASSWORD=postgres              # PostgreSQL password
POSTGRES_DATABASE=postgres              # Database to back up

# Encryption and Backup
PASSPHRASE=passphrase                   # Passphrase for encrypting backups
S3_PATH=backup                          # Path in MinIO for storing backups
```

> **Note**: Ensure sensitive information (such as access keys and passwords) is securely managed and not shared publicly.

---

## Project Structure

```plaintext
.
├── backup-policy.json      # Defines access policies for backup storage
├── compose.yml             # Docker Compose file for backup service deployment
├── deploy.sh               # Script for deploying the backup service
└── README.md               # This deployment guide
```

### Files Overview

- **backup-policy.json**: Defines permissions in MinIO for managing backup storage securely.
- **compose.yml**: Configures the backup service, including environment variables, scheduling, and network connections.
- **deploy.sh**: Automates the deployment of the backup service.
- **README.md**: Deployment and usage guide.

---

## Deployment Steps

1. **Set Up Environment Variables**: Ensure all required environment variables are set in `.env` as described above.

2. **Deploy the Backup Service**: Run the `deploy.sh` script to set up and start the backup service.

   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

   This script will:
   - Remove any existing backup deployment.
   - Load environment variables from `.env`.
   - Deploy the backup service stack with Docker Compose.

3. **Verify Deployment**: The service will start and run backups on the specified schedule. Check the logs to confirm successful backups.

---

## Service Configuration

### Docker Compose

The `compose.yml` file defines the backup service, which connects to both MinIO and PostgreSQL networks:

- **Networks**:
  - `minio`: Connects to MinIO for storing backups.
  - `pg_net`: Connects to PostgreSQL for accessing the database.

- **Environment Variables**: Key settings include:
  - `S3_ENDPOINT`, `S3_BUCKET`, `S3_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` for MinIO configuration.
  - `POSTGRES_HOST`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DATABASE` for PostgreSQL credentials.
  - `SCHEDULE` and `BACKUP_KEEP_DAYS` for setting backup frequency and retention.

### Scheduled Backups

Backups are scheduled using the `SCHEDULE` variable in `compose.yml`, which uses cron syntax. For example:

```plaintext
SCHEDULE: '*/4 * * * *' # Runs every 4 hours
```

Adjust the cron expression as needed to set a different frequency. By default, backups are retained for 7 days (`BACKUP_KEEP_DAYS: 7`), with older backups automatically deleted.

---

## Scheduling and Retention

- **Scheduling**: Controlled by the `SCHEDULE` variable in cron format.
- **Retention**: Set by `BACKUP_KEEP_DAYS`. This variable specifies how many days backups should be kept. Older backups beyond this retention period are deleted automatically.

---

## Troubleshooting

1. **Connection Issues**:
   - Verify network connectivity between MinIO and PostgreSQL.
   - Ensure MinIO and PostgreSQL are correctly configured and accessible.

2. **Permission Errors**:
   - Ensure the MinIO access keys (`S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY`) are correct.
   - Confirm that the backup policy (`backup-policy.json`) grants sufficient permissions for uploading and deleting files in the `back-up` bucket.

3. **Failed Backups**:
   - Check logs for error messages related to PostgreSQL or MinIO.
   - Ensure sufficient storage space is available in MinIO and that PostgreSQL has no connection issues.

4. **SSL and Endpoint**:
   - If using HTTPS with MinIO, ensure `S3_ENDPOINT` is configured with the correct protocol (`https://`) and certificate issues are resolved.

---

Following these instructions will help you deploy and manage the backup service, ensuring automated, scheduled backups of the PostgreSQL database stored securely in MinIO. For more advanced troubleshooting or configuration questions, consult the team lead or refer to the [Postgres Backup S3 Docker documentation](https://hub.docker.com/r/eeshugerman/postgres-backup-s3).
