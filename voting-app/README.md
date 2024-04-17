# Voting App

The Voting App is a Docker Swarm-based application designed to facilitate voting between two options and display real-time voting results. This README provides an overview of the project structure, its components, and instructions for deployment and usage.

## Table of Contents

1. [Overview](#overview)
2. [Deployment](#deployment)
3. [Usage](#usage)
4. [Configuration](#configuration)

## Overview

The Voting App comprises several services deployed on a Docker Swarm cluster. It includes a voting service (vote), a worker service (worker), a result service (result), a PostgreSQL database (postgres), and a Redis cluster (redis). These services are orchestrated using Docker Swarm's declarative syntax to ensure scalability and reliability.

## Deployment

To deploy the Voting App on your Docker Swarm cluster, follow these steps:

1. Ensure you have a Docker Swarm cluster set up. If not, initialize a swarm by running:
   ```bash
   docker swarm init
   ```

2. Clone this repository to your local machine:
   ```bash
   git clone <repository_url>
   ```

3. Navigate to the root directory of the project:
   ```bash
   cd voting-app
   ```

4. Set up the environment variables by creating a `.env` file with the following content:
   ```bash
   DOMAIN=harimi.ir
   VOTE_SUB=vote
   RESULT_SUB=result
   ```

5. Deploy the stack using the provided `docker-compose.yml` file:
   ```bash
   docker stack deploy -c docker-compose.yml voting_app
   ```

## Usage

Once deployed, you can access the Voting App frontend by visiting the following URLs in your web browser:

- Voting Page: [http://vote.harimi.ir](http://vote.harimi.ir)
- Result Page: [http://result.harimi.ir](http://result.harimi.ir)

## Configuration

- **Traefik Configuration:** The Traefik labels in the `docker-compose.yml` file define routing rules and enable HTTPS for the voting and result services.
- **PostgreSQL Configuration:** The PostgreSQL service utilizes Bitnami's PostgreSQL image with replication manager for high availability. It also includes a pgpool service for connection pooling.
- **Redis Configuration:** The Redis cluster consists of a master, multiple slaves, and sentinel instances for high availability and monitoring. HAProxy is used as a proxy for the Redis cluster.
