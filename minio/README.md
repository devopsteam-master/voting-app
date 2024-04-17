# Minio

Minio is an object storage server compatible with Amazon S3. This directory contains Docker Compose files and configuration for deploying Minio in a Docker Swarm cluster.

## Table of Contents
1. [Overview](#overview)
2. [Components](#components)
3. [Deployment](#deployment)
4. [Usage](#usage)
5. [Configuration](#configuration)

## Overview
Minio is deployed as a distributed system with two Minio server instances for redundancy and fault tolerance. Additionally, a script is provided to create buckets and configure access policies using the Minio command-line tool (mc).

## Components
### Minio Servers (`minio` and `minio-2`):
- Docker images: `quay.io/minio/minio:${MINIO_MINIO_VERSION:-latest}`
- Replicas: 1 each
- Networks: `minio`, `traefik-net`, `prometheus`
- Volumes: `minio-data`
- Environment variables:
  - `MINIO_ROOT_USER`: Root user for Minio
  - `MINIO_ROOT_PASSWORD`: Root password for Minio
- Labels for Traefik integration

### Bucket Creation Script (`createbuckets`):
- Docker image: `quay.io/minio/mc:${MINIO_MC_VERSION:-latest}`
- Depends on: `minio`, `minio-2`
- Networks: `minio`
- Configs: `mimir-policy`, `loki-policy`
- Environment variables: `BUCKETS`, `MINIO_USER`, `MINIO_PASSWORD`
- Entry point: Script to create buckets and configure access policies

## Deployment
To deploy Minio, follow these steps:
1. Ensure you have a Docker Swarm cluster set up.
2. Navigate to the "minio" directory.
3. Set up the required environment variables in a `.env` file.
4. Deploy the Minio stack using the provided Docker Compose file:
   ```bash
   docker stack deploy -c docker-compose.yml minio
   ```

## Usage
Once deployed, you can access Minio using the configured hostname and port (default: `http://minio.<DOMAIN>:9000`). Additionally, buckets are automatically created and configured according to the specified policies.

## Configuration
### Minio Configuration:
- The Minio servers are configured with environment variables for setting up the root user and password.
- Labels are provided for Traefik integration to enable HTTPS and routing.

### Bucket Creation Script Configuration:
- The script (`createbuckets`) is configured with environment variables for specifying bucket names and user credentials.
- Access policies for buckets are configured using the Minio command-line tool (`mc`) and policy configuration files.