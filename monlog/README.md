## Monlog

Monlog is a monitoring and logging solution based on Prometheus, Grafana, Loki, and Alertmanager. This directory contains Docker Compose files and configuration for deploying and managing the Monlog components in a Docker Swarm cluster.

### Table of Contents

- [Overview](#overview)
- [Deployment](#deployment)
- [Configuration](#configuration)
- [Usage](#usage)

### Overview

Monlog provides a comprehensive solution for monitoring and logging various aspects of a system or application. It includes the following components:

- **Prometheus**: An open-source monitoring and alerting toolkit.
- **Grafana**: A multi-platform open-source analytics and interactive visualization web application.
- **Loki**: A horizontally-scalable, highly-available log aggregation system inspired by Prometheus.
- **MIMIR**: A microservice for handling alerts and notifications.
- **Alertmanager**: Handles alerts sent by client applications such as the Prometheus server.

### Deployment

Deployment of Monlog components is managed using Docker Swarm. Each component is deployed as a separate service stack using Docker Compose files.

#### 1. Deploying Prometheus:

```bash
docker stack deploy -c docker-compose.yml monlog
```

#### 2. Deploying Exporters:

```bash
docker stack deploy -c exporter-compose.yml exporters
```

#### 3. Deploying MIMIR:
first we need to go in mimir directory and use:
```bash
docker stack deploy -c docker-compose.yml mimir
```

Ensure you have configured the necessary environment variables in each component's Docker Compose file before deploying. You can scale the services according to your requirements by adjusting the `replicas` field in the Docker Compose files.

### Configuration

Configuration files for each Monlog component are provided within their respective directories. These files define settings such as alerting rules, data sources, and service endpoints. Modify these files as needed to customize the behavior of each component.

### Usage

Once deployed, the monitoring and logging interfaces will be accessible using the configured hostnames and ports. You can access the Grafana dashboard, Prometheus metrics, Loki logs, and Alertmanager alerts via their respective URLs.
Once deployed, access the monitoring and logging interfaces using the configured hostnames and ports:

- Prometheus: http://prometheus.<DOMAIN>:9090
- Grafana: http://grafana.<DOMAIN>:3000
- Loki: http://loki.<DOMAIN>:3100
- Alertmanager: http://alertmanager.<DOMAIN>:9093
