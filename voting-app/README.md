# Voting App Infrastructure
The Voting App is a microservices-based application designed to demonstrate a modern, scalable, and resilient infrastructure. Deployed on a Docker Swarm cluster, it showcases a voting service, a worker service, a result service, alongside PostgreSQL and Redis clusters for data management and caching. The orchestration is managed through Docker Swarm's declarative syntax, ensuring the application's scalability and reliability.

## Services Overview
-  **Vote Service**: A front-end web application where users can cast their votes.
-  **Worker Service**: A .NET service that processes votes and stores them in the database.
-  **Result Service**: A Node.js web application that displays voting results.
-  **PostgreSQL Database**: Stores the final voting results with high availability and data replication.
-  **Redis Cluster**: Manages temporary votes and acts as a message broker between the vote and worker services.

## Configuration Details

### Traefik Configuration
Traefik is used as a reverse proxy and load balancer, providing dynamic routing and HTTPS termination for the voting and result services. The configuration is specified through labels in the `docker-compose.yml` file, enabling automatic discovery and configuration of services based on their deployment state.

-  **HTTPS Support**: Utilizes Let's Encrypt for automatic SSL certificate generation and renewal, ensuring secure communication.
-  **Routing Rules**: Defines host-based routing rules for directing traffic to the appropriate services, facilitating access to the voting and result interfaces.
### PostgreSQL Configuration
The PostgreSQL setup leverages [Bitnami's PostgreSQL image](https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr), enhanced with Replication Manager (repmgr) for automated failover and high availability. It also integrates [Pgpool](https://github.com/bitnami/containers/tree/main/bitnami/pgpool) for efficient connection pooling and load balancing.

-  **Replication**: Configured for master-slave replication, ensuring data redundancy and high availability.
-  **Pgpool**: Manages a pool of connections to the PostgreSQL nodes, providing load balancing and seamless failover mechanisms.

### Redis Configuration
The [Redis](https://github.com/bitnami/containers/tree/main/bitnami/redis) configuration employs a master-slave setup with [Sentinel](https://github.com/bitnami/containers/tree/main/bitnami/redis-sentinel) for high availability and failover. [HAProxy](https://hub.docker.com/_/haproxy) is utilized to distribute traffic across the Redis instances, ensuring efficient load balancing and robustness.

-  **High Availability**: Redis Sentinel monitors the master and slave instances, promoting a slave to master if the current master becomes unresponsive.
-  **Load Balancing**: HAProxy routes traffic to the available Redis instances, optimizing resource utilization and response times.
