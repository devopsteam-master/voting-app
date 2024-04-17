# DevOps Project: Monster

# Overview

Welcome to the Monster repository, a comprehensive solution designed for deploying and managing a Docker Swarm-based application. This project is part of a DevOps class led by Mr. Ahmad Rafiee and focuses on practical, hands-on experience with modern DevOps tools and practices.

This repository contains the infrastructure code and configurations necessary to deploy a multi-service application using Docker Swarm. It includes Docker Compose files, service definitions, and scripts for automated deployment and management.

# Features

-   **Docker Swarm Deployment**: Utilize Docker Swarm for deploying a distributed application.
-   **Continuous Integration and Deployment (CI/CD)**: Automated pipelines using GitLab CI/CD for building, testing, and deploying services.
-   **Security Scanning**: Integrated container scanning to ensure images are free from vulnerabilities.
-   **Automated Testing**: Automated testing to ensure code changes do not break existing functionality.
-   **Environment-Specific Deployment**: Support for deploying to different environments such as pre-production and production.

# Prerequisites

-   Docker and Docker Compose
-   GitLab account (for CI/CD)
-   Access to a Docker registry

# Setup

1.  Clone the repository to your local machine.
2.  Ensure Docker Swarm is initialized on your target deployment environment.
3.  Configure environment variables as needed for the services and CI/CD pipeline.

# Deployment

Deployment can be performed manually using the  `deploy.sh`  script or automatically through the GitLab CI/CD pipeline.

#### Manual Deployment

Run the  `deploy.sh`  script to deploy the services to a Docker Swarm:

```bash
bash -c ./deploy.sh
```

This script sets up necessary networks, deploys Traefik as a reverse proxy, sets up databases, and deploys the application stack along with monitoring and backup services.

#### CI/CD Pipeline

The  `.gitlab-ci.yml`  file defines the CI/CD pipeline stages:

-   **Build**: Builds Docker images for the application services.
-   **Test**: Runs automated tests to ensure the application is functioning correctly.
-   **Deploy**: Deploys the application to specified environments based on the pipeline configuration.


# Services Overview

#### Voting App

-   **Python App (Vote Service):**  A Flask-based web application allowing users to vote between two options. It's deployed with Docker and scales across multiple instances for high availability.
-   **Node.js App (Result Service):**  A Node.js application that displays the voting results in real time. It queries the PostgreSQL database and presents an interface with live updates using WebSockets.
-   **.NET App (Worker Service):**  A .NET Core application responsible for processing votes stored in Redis and updating the PostgreSQL database with the tally. It acts as a bridge between the vote queue and the database.

#### Data Storage and Caching

-   **PostgreSQL:**  Configured with replication for high availability and data persistence. It stores the final voting results.
-   **Redis:**  Utilized for caching and as a temporary store for votes before they are processed by the worker service. It's set up with replication for resilience and HAProxy for separating read and write connections, optimizing performance and reliability.

#### Load Balancing and Reverse Proxy

-   **HAProxy:**  Manages Redis connections by directing write operations to the master node and read operations to slave nodes, ensuring efficient load distribution and fault tolerance.
-   **Traefik:**  Serves as the entry point to the application, routing and balancing incoming HTTP requests to the appropriate services. It's configured for automatic SSL termination and integrates with Let's Encrypt for certificate management.

#### Object Storage

-   **MinIO:**  An S3-compatible object storage service used for storing backups and logs. It provides a resilient and accessible storage solution that integrates with the rest of the infrastructure for backup operations and log storage.

#### Monitoring and Logging

-   **Prometheus:**  Collects and stores metrics from the various services and infrastructure components. It's configured for scraping metrics endpoints and storing time-series data.
-   **Grafana:**  Visualizes the metrics collected by Prometheus through dashboards, offering insights into the application and infrastructure performance.
-   **Mimir:**  Serves as a scalable, long-term storage solution for Prometheus metrics, configured with clustering to handle Prometheus remote write requests efficiently.
-   **Loki:**  Aggregates and stores logs from all services, providing a centralized logging solution that integrates with Grafana for log visualization.
-   **Promtail:**  Installed on each node, it tails logs and forwards them to Loki, ensuring that logs from all services are collected and available for analysis.
-   **Pushgateway:**  Allows ephemeral and batch jobs to expose their metrics to Prometheus. It's used for capturing metrics from jobs that do not run long enough to be scraped.
-   **Alertmanager:**  Manages alerts generated by Prometheus, handling deduplication, grouping, and routing of alerts to the correct receiver while ensuring notifications are sent out.
#### Backup Solution

- **Restic:** Utilized for backing up critical data, including PostgreSQL databases. Configured to store backups in MinIO, providing secure and efficient data storage and recovery capabilities. Restic is integrated into the infrastructure to automate backup processes, ensuring data integrity and availability.

This comprehensive setup ensures high availability, resilience, and scalability of the voting application, while providing deep insights into its performance and operational health through advanced monitoring and logging capabilities.


# Contributing

Contributions are welcome! Please read our contributing guidelines for how to propose changes to this project.
## License

This project is licensed under the [GNU General Public License v3.0](./LICENSE).