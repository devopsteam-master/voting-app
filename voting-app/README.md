# Project Overview: Multi-Service Application with Redis, PostgreSQL, HAProxy, and WordPress

Welcome to the multi-service application project! This guide will walk you through the setup, configuration, and deployment of each component in this project. By the end of this document, you should have a clear understanding of how requests flow through the application, how each service interacts, and how to manage and monitor the system.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Environment Setup](#environment-setup)
3. [Service Overview](#service-overview)
   - [Vote Service](#vote-service)
   - [Worker Service](#worker-service)
   - [Result Service](#result-service)
   - [Redis](#redis)
   - [PostgreSQL](#postgresql)
   - [HAProxy](#haproxy)
   - [WordPress and MariaDB](#wordpress-and-mariadb)
4. [Deployment Steps](#deployment-steps)
5. [Request Flow](#request-flow)
6. [Monitoring and Scaling](#monitoring-and-scaling)
7. [Troubleshooting](#troubleshooting)

---

## Project Structure

```plaintext
.
├── deploy.sh                 # Main deployment script
├── docker-compose.yml        # Primary Compose file for main services
├── postgres/
│   ├── docker-compose.yml    # Compose file for PostgreSQL services
│   └── pgpool.conf           # Configuration for pgpool for PostgreSQL
├── redis/
│   ├── deploy.sh             # Redis deployment script
│   ├── docker-compose.yml    # Compose file for Redis services
│   └── haproxy.cfg           # Configuration for HAProxy to monitor Redis
├── result/
│   ├── Dockerfile            # Dockerfile for result service
│   └── ...
├── vote/
│   ├── Dockerfile            # Dockerfile for vote service
│   └── ...
└── worker/
    ├── Dockerfile            # Dockerfile for worker service
    └── ...
```

## Environment Setup

### 1. Environment Variables

Create a `.env` file at the root of the project with the following variables:

```plaintext
DOMAIN=YourDomain
VOTE_SUB=VoteSubDomain
RESULT_SUB=ResultSubDomain
HAPROXY_SUB=HaproxySubDomain

# Redis Auth
HAPROXY_AUTH_USER=UserName
HAPROXY_AUTH_PASS=HashedPassword

# Registry information
REPOSITORY_NAME=registry.yourdomain

# Vote options
OPTION_A=Gandom
OPTION_B=Amoo

# Docker image references
VOTE_IMAGE=${REPOSITORY_NAME}/vote:v1
WORKER_IMAGE=${REPOSITORY_NAME}/worker:v1
RESULT_IMAGE=${REPOSITORY_NAME}/result:v1

# PostgreSQL Configurations
POSTGRESQL_POSTGRES_PASSWORD=postgres
POSTGRESQL_USERNAME=postgres
POSTGRESQL_PASSWORD=postgres
POSTGRESQL_DATABASE=postgres
REPMGR_PASSWORD=postgres
REPMGR_USERNAME=postgres
PGPOOL_ADMIN_USERNAME=Username
PGPOOL_ADMIN_PASSWORD=Password
```

## Service Overview

### Vote Service

- **Purpose**: Handles user voting. Users can choose between two options (`OPTION_A` and `OPTION_B`).
- **Flow**: Accepts votes, stores them temporarily in Redis, and forwards data to the `worker` service for processing.
- **Traefik Configuration**: Exposes the service via `VOTE_SUB.DOMAIN`, with HTTP and HTTPS handled by Traefik.

### Worker Service

- **Purpose**: Processes votes from Redis and writes them to PostgreSQL for persistence.
- **Flow**: Acts as a bridge between `vote` (input) and `PostgreSQL` (final storage).
- **Network**: Connects to both `redis` and `pg_net` networks to interact with Redis and PostgreSQL.

### Result Service

- **Purpose**: Displays voting results from PostgreSQL.
- **Flow**: Retrieves data from PostgreSQL and renders results via a web interface.
- **Traefik Configuration**: Exposes the service via `RESULT_SUB.DOMAIN`, with HTTP and HTTPS support through Traefik.

### Redis

- **Components**: 
  - `redis-master`: Primary instance for Redis.
  - `redis-slave`: Replica instances for load balancing.
  - `redis-sentinel`: Monitors Redis health and manages failover.
- **HAProxy Integration**: HAProxy monitors Redis services, handling TCP connections and ensuring high availability.
- **Replication**: Data is replicated from `redis-master` to `redis-slave` instances.

### PostgreSQL

- **Components**:
  - `pg`: Replication-managed PostgreSQL cluster for high availability.
  - `db`: Pgpool service for load balancing and monitoring PostgreSQL nodes.
- **pgpool**: Configured to manage replication and load balancing between PostgreSQL instances.
- **HAProxy Integration**: HAProxy routes requests for PostgreSQL to ensure availability and load distribution.

### HAProxy

- **Purpose**: Manages traffic between services and adds redundancy.
- **Redis Monitoring**: Uses `haproxy.cfg` to monitor Redis master and slave nodes.
- **PostgreSQL Monitoring**: Monitors PostgreSQL cluster nodes, ensuring continuous availability.
- **Traefik Integration**: Secures HTTP/HTTPS access to services, with SSL termination and redirection.

### WordPress and MariaDB

- **Components**:
  - **WordPress**: Hosted on a subdomain defined by `${WP_SUB}.${DOMAIN}`.
  - **MariaDB**: Managed as a Galera cluster with HAProxy for load balancing.
- **Flow**: HAProxy routes requests from WordPress to the MariaDB Galera cluster for database access.

## Deployment Steps

1. **Initialize Networks**: Ensure the following overlay networks are created:
   ```bash
   docker network create --driver overlay redis
   docker network create --driver overlay pg_net
   docker network create --driver overlay web_net
   docker network create --driver overlay mariadb_galera-network
   ```

2. **Deploy PostgreSQL Stack**:
   ```bash
   cd postgres
   ./deploy.sh
   ```

3. **Deploy Redis Stack**:
   ```bash
   cd redis
   ./deploy.sh
   ```

4. **Deploy Main Application Stack**:
   ```bash
   cd ..
   ./deploy.sh
   ```

5. **Verify Traefik and HAProxy**:
   - Ensure that Traefik routes are properly configured for `vote`, `result`, and HAProxy stats.
   - Access the HAProxy stats at `http://{HAPROXY_SUB}.${DOMAIN}`.

## Request Flow

1. **Vote Request**:
   - Users interact with the `vote` service via a web interface to cast votes.
   - Votes are temporarily stored in `redis-master` and replicated to `redis-slave` nodes.

2. **Worker Processing**:
   - The `worker` service retrieves votes from Redis, processes them, and stores them in PostgreSQL through Pgpool.

3. **Result Display**:
   - The `result` service fetches aggregated vote data from PostgreSQL and displays it on a user-friendly interface.

4. **HAProxy Monitoring**:
   - Redis: Monitors master and replica nodes, ensuring Redis remains responsive and highly available.
   - PostgreSQL: Routes requests to the primary PostgreSQL node or Pgpool if failover is required.

## Monitoring and Scaling

### Scaling Services

- **Vote** and **Result** services are configured with Traefik and can be scaled using Docker Swarm by modifying the replica count in `docker-compose.yml`.
- **Worker**: Scaling is limited by available Redis and PostgreSQL capacity.

### HAProxy Monitoring

Access HAProxy stats at:
```plaintext
http://${HAPROXY_SUB}.${DOMAIN}
```
This interface provides health status, connection metrics, and service performance data.

## Troubleshooting

1. **Redis Failover Issues**:
   - Check `haproxy.cfg` for Redis health checks and ensure `redis-sentinel` is correctly configured for master detection.
   - Monitor logs using:
     ```bash
     docker logs redis-master
     docker logs redis-slave
     ```

2. **PostgreSQL Replication Errors**:
   - Verify replication in `pgpool.conf` and ensure `pg` nodes are properly synced.
   - For detailed logs:
     ```bash
     docker logs pg
     docker logs db
     ```

3. **Service Unreachable**:
   - Check network connectivity in Docker:
     ```bash
     docker network inspect web_net
     docker network inspect pg_net
     ```

Following this guide will ensure that the multi-service application runs smoothly, with high availability and efficient load balancing across services. For more specific configuration changes or scaling strategies, consult each service’s configuration files and Docker documentation.
