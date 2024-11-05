# MinIO Deployment Guide

MinIO is a high-performance, distributed object storage system compatible with the Amazon S3 API. It’s ideal for managing data backups, especially for applications that require secure and scalable storage. In this project, MinIO is deployed in a Docker environment and configured with Traefik for secure access and SSL certificate management.

This document provides instructions for setting up MinIO, configuring Traefik and SSL, and managing data buckets and access policies.

---

## Table of Contents

1. [Overview of MinIO](#overview-of-minio)
2. [Environment Variables](#environment-variables)
3. [Project Structure](#project-structure)
4. [Deployment Steps](#deployment-steps)
5. [Using MinIO](#using-minio)
6. [Backup Policy Explanation](#backup-policy-explanation)
7. [Troubleshooting](#troubleshooting)

---

## Overview of MinIO

MinIO serves as a cloud-native object storage solution that can store unstructured data, such as backups, logs, and media files. It is designed for high availability and performance, providing secure storage accessible via the S3-compatible API. In our setup, MinIO is deployed with:

- **Backup Buckets**: Set up during deployment using `createbuckets` service.
- **Custom Backup Policies**: Defined in `backup-policy.json` to restrict access to specific actions like uploading, downloading, and deleting files.

---

## Environment Variables

Ensure a `.env` file is present at the root of your project with the following environment variables:

```plaintext
DOMAIN=YourDomainAddress
MINIO_SUB=minio
MINIO_SUB1=apiminio

BUCKETS='back-up'

MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=RootPassword
MINIO_BACKUP_USER=UserName
MINIO_BACKUP_PASSWORD=Password

MINIO_MINIO_VERSION=RELEASE.2024-03-30T09-41-56Z
MINIO_MC_VERSION=RELEASE.2024-03-30T15-29-52Z
RESTART_POLICY=always
```

---

## Project Structure

```plaintext
.
├── backup-policy.json      # JSON file defining access policies for backup
├── compose.yml             # Docker Compose file for deploying MinIO
├── deploy.sh               # Script for deploying the MinIO stack
└── README.md               # Deployment guide (this file)
```

### Files Overview

- **backup-policy.json**: Specifies permissions for `backup` buckets in MinIO. This policy allows specific actions (Get, Put, Delete, List) on the `back-up` bucket.
- **compose.yml**: Docker Compose file defining MinIO and `createbuckets` service for setting up buckets and user policies.
- **deploy.sh**: Shell script for deploying MinIO and configuring environment variables.
- **README.md**: This deployment guide.

---

## Deployment Steps

### 1. Configure Environment Variables

Update the `.env` file with the required values for `MINIO_ROOT_USER`, `MINIO_ROOT_PASSWORD`, `MINIO_BACKUP_USER`, and `MINIO_BACKUP_PASSWORD`. These values are critical for setting up access to MinIO and managing backups securely.

### 2. Deploy MinIO

Run the `deploy.sh` script to deploy MinIO.

```bash
chmod +x deploy.sh
./deploy.sh
```

This script will:
- Remove any previous MinIO deployment.
- Load the environment variables from `.env`.
- Deploy MinIO and `createbuckets` service with Docker Compose in detached mode.

### 3. Access MinIO

Once deployed, MinIO can be accessed at the following URL (ensure Traefik is properly configured):

```plaintext
https://minio.YourDomain Address
```

Login using the `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` from your `.env` file.

---

## Using MinIO

### Buckets and Backup Management

The `createbuckets` service automatically creates and configures buckets defined in the `BUCKETS` environment variable. In this setup, we use a `back-up` bucket specifically for backup data. The bucket creation and access policy setup are handled by `createbuckets` during the initial deployment.

#### Accessing Buckets

You can manage objects within the `back-up` bucket through MinIO’s web console or programmatically via the S3-compatible API.

### Traefik Configuration

The `compose.yml` file includes Traefik labels that enable HTTPS access to MinIO. Traefik routes traffic based on the `MINIO_SUB` and `DOMAIN` specified in `.env`:

- **HTTP**: Automatically redirects to HTTPS.
- **HTTPS**: Secured using Let’s Encrypt certificates configured in Traefik.

### Creating Additional Buckets or Users

To create additional buckets, you can modify the `BUCKETS` variable in `.env` and redeploy `createbuckets`. User access and permissions can be managed in the MinIO admin console.

---

## Backup Policy Explanation

### `backup-policy.json`

The `backup-policy.json` file defines permissions for the `back-up` bucket, allowing specific actions on objects within this bucket. Here’s a breakdown of the permissions:

- **Allowed Actions**:
  - `s3:GetObject`: Download objects from the bucket.
  - `s3:PutObject`: Upload objects to the bucket.
  - `s3:DeleteObject`: Delete objects from the bucket.
  - `s3:ListBucket`: List objects within the bucket.
  - `s3:AbortMultipartUpload`: Abort multipart uploads in progress.
  - `s3:ListMultipartUploadParts`: List parts of a multipart upload.
  
- **Resources**:
  - `arn:aws:s3:::back-up`: The `back-up` bucket.
  - `arn:aws:s3:::back-up/*`: All objects within the `back-up` bucket.

This policy is applied to the `MINIO_BACKUP_USER`, allowing this user to perform the specified actions on the `back-up` bucket only.

---

## Troubleshooting

1. **MinIO Not Accessible**:
   - Ensure Traefik is running and configured correctly.
   - Verify that `MINIO_SUB` and `DOMAIN` are properly set in `.env`.

2. **Bucket Not Created**:
   - Check the `createbuckets` service logs to ensure it has run without errors.
   - Verify that `BUCKETS` is set correctly in `.env`.

3. **Permission Issues**:
   - Confirm that `backup-policy.json` is correctly formatted and matches the bucket name in `BUCKETS`.
   - Ensure `MINIO_BACKUP_USER` and `MINIO_BACKUP_PASSWORD` are set correctly and that the `backup-policy` is attached.

4. **SSL Certificate Errors**:
   - Ensure `MINIO_SUB` and `DOMAIN` resolve to your server’s IP address.
   - Check Traefik logs for certificate issuance errors.

Following this guide will help you set up, access, and manage the MinIO service, with secure access and backup configurations in place. For any issues not covered here, refer to MinIO’s [official documentation](https://min.io/docs/minio/server/administration-guide.html) or consult with a senior team member.
