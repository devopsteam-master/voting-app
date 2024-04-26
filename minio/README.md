# MinIO Directory Overview

This directory contains the configurations and Docker Compose files necessary for deploying MinIO, an S3-compatible object storage service, as part of the Monster project's infrastructure. MinIO is used for storing backups, logs, and any other data that requires durable, accessible storage. The setup supports both single-node and distributed modes, ensuring flexibility and scalability according to the deployment needs.


## Directory Structure

- **docker-compose.yml**: Docker Compose file for deploying MinIO in distributed mode.
- **docker-compose-single-node.yml**: Docker Compose file for deploying MinIO in single-node mode for development or testing.
- **.env**: Environment variables file containing configuration options like MinIO access and secret keys, version, and bucket names.
- **mimir-policy.json**, **loki-policy.json**, **backup-policy.json**: JSON files defining policies for different operational requirements.

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your machine.
- Basic understanding of Docker Compose and MinIO.

### Deployment

1. **Configure Environment Variables**: Copy the `.env.example` to `.env` and adjust the variables to match your environment and security requirements.
2. **Choose Deployment Mode**:
   - For **single-node** deployment, use `docker-compose-single-node.yml`.
   - For **distributed** deployment, use `docker-compose.yml`.
3. **Deploy MinIO**:
   ```bash
    docker-compose -f docker-compose.yml up -d # For distributed mode
   ```
   or

   ```bash
    docker-compose -f docker-compose-single-node.yml up -d # For single-node mode
   ```