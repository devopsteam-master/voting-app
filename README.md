# DevOps Project: Monster

## Overview

Welcome to the "Monster" DevOps project! This comprehensive project incorporates various components related to Docker, Ansible, monitoring, backup servers, and more, all orchestrated for efficient and reliable operations.

## Project Structure

- **[ansible/](./ansible/README.md)**: Contains Ansible playbooks and roles for system hardening and Docker orchestration.
- **[backup-server/](./backup-server/README.md)**: Configuration for a backup server using Restic and Minio for storage.
- **[minio/](./minio/README.md)**: Docker configurations for deploying Minio, an object storage server.
- **[monlog/](./monlog/README.md)**: Docker configurations for monitoring and logging solutions including Prometheus, Grafana, Loki, and Promtail.
- **[traefik/](./traefik/README.md)**: Configuration for Traefik, a modern HTTP reverse proxy and load balancer.
- **[voting-app/](./voting-app/README.md)**: Docker configurations for a simple voting application with Redis, PostgreSQL, and a worker component.

## Detailed Description

This project aims to provide a comprehensive DevOps solution for deploying and managing various components of a modern application stack. Here's a breakdown of each section:

- **Ansible**: Handles server provisioning, configuration management, and automation tasks using Ansible playbooks and roles.
- **Backup Server**: Configures a backup server using Restic and Minio for secure and scalable backups of critical data.
- **Minio**: Deploys Minio, an open-source object storage server compatible with Amazon S3, for storing and accessing large volumes of unstructured data.
- **Monitoring & Logging**: Sets up monitoring and logging solutions using Prometheus, Grafana, Loki, and Promtail for collecting, visualizing, and analyzing system metrics and logs.
- **Traefik**: Configures Traefik as a modern HTTP reverse proxy and load balancer to route incoming requests to appropriate services in the stack.
- **Voting App**: Provides Docker configurations for a simple voting application, showcasing the integration of Redis, PostgreSQL, and a worker component.

## Usage

To deploy the project, follow the instructions in each component's README file. Ensure you have Docker and Docker Swarm set up for deployment, and Ansible for server configuration.

## License

This project is licensed under the [GNU General Public License v3.0](./LICENSE).
