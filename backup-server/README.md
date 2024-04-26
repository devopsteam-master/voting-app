# Backup Server Directory Overview

This directory contains the necessary configurations for setting up a backup server using Docker, Restic, and MinIO for S3-compatible storage. The setup is designed to automate the backup and pruning of PostgreSQL databases, ensuring data durability and recoverability.

## Features

- **Automated Backups**: Utilizes Restic for efficient, encrypted backups of PostgreSQL databases to an S3-compatible storage (MinIO).
- **Scheduled Pruning**: Automatically prunes old backups based on configured retention policies to manage storage space effectively.
- **Monitoring and Alerts**: Integrates with Prometheus for monitoring backup and prune operations, with the capability to alert on failures.

## Components

- **Docker Compose**: Orchestrates the deployment of the backup, prune, and check services using the `docker-compose.yml` file.
- **Restic**: Handles the backup, prune, and integrity check operations.
- **MinIO**: S3-compatible storage used for storing the backup data.
- **Prometheus**: Monitoring and alerting for backup operations.

## Configuration

### Environment Variables

- **`.env`**: Contains the necessary environment variables for configuring the backup operations, including the Restic repository location, access credentials for MinIO, and the encryption password for Restic.

  Key variables include:
  - `RESTIC_REPOSITORY`: URL to the MinIO bucket.
  - `RESTIC_PASSWORD`: Encryption password for Restic.
  - `MINIO_BACKUP_USER`: Username for MinIO access.
  - `MINIO_BACKUP_PASSWORD`: Password for MinIO access.

### Docker Compose

- **`docker-compose.yml`**: Defines the services required for the backup operations, including:
  - `pgbackups`: PostgreSQL backup service.
  - `backup`: Restic backup service.
  - `prune`: Restic prune service.
  - `check`: Restic integrity check service.

## Usage

1. **Configure Environment Variables**: Copy the `.env.example` to `.env` and adjust the variables to match your deployment.
2. **Deploy Services**: Run `docker-compose up -d` to start the backup services.
3. **Monitor Operations**: Check Prometheus for monitoring and alerts on the backup operations.

## Further Reading

- [Postgres-backup-local project](https://github.com/prodrigestivill/docker-postgres-backup-local)
- [Restic Documentation](https://restic.readthedocs.io)
- [MinIO Documentation](https://docs.min.io)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

This README provides a comprehensive guide to the backup server setup within the project, ensuring that users and contributors have a clear understanding of its configuration, components, and operation.