#!/bin/bash
set -e
set -a

# Define the overlay networks to create
NETWORKS=("web_net" "minio_net" "pg_net")

# Create overlay networks
echo "Creating overlay networks..."
for network in "${NETWORKS[@]}"; do
  if ! docker network ls | grep -q "$network"; then
    docker network create --attachable=true --driver=overlay "$network"
    echo "Created network: $network"
  else
    echo "Network $network already exists"
  fi
done

# Load environment variables and deploy Traefik
echo "Deploying Traefik..."
source traefik/webapp.env
docker stack deploy -c traefik/compose.yml traefik
echo "Traefik deployed."

# Deploy MinIO
echo "Deploying MinIO..."
source minio/.env
docker stack deploy -c minio/compose.yml minio
echo "MinIO deployed."

# Deploy Vaultwarden (Vault service)
echo "Deploying Vaultwarden..."
source vault/.env
docker stack deploy -c vault/docker-compose.yml vault
echo "Vaultwarden deployed."

# Deploy Backup Server
echo "Deploying Backup Server..."
source backup-server/.env
docker stack deploy -c backup-server/compose.yml backup
echo "Backup Server deployed."

# Deploy Vote Stack (includes Vote, Result, Worker, Redis)
echo "Deploying Vote Stack..."
source voting-app/.env
docker stack deploy -c voting-app/docker-compose.yml vote-stack
echo "Vote Stack deployed."

# Deploy Redis (if separate from Vote Stack)
echo "Deploying Redis..."
source voting-app/redis/.env
docker stack deploy -c voting-app/redis/docker-compose.yml redis
echo "Redis deployed."

# Deploy PostgreSQL Stack
echo "Deploying PostgreSQL Stack..."
source voting-app/postgres/.env
docker stack deploy -c voting-app/postgres/docker-compose.yml postgres-stack
echo "PostgreSQL Stack deployed."

# Deploy MariaDB (for WordPress)
echo "Deploying MariaDB Stack..."
source wordpress/mariadb/.env
docker stack deploy -c wordpress/mariadb/compose.yml mariadb
echo "MariaDB Stack deployed."

# Deploy WordPress
echo "Deploying WordPress..."
source wordpress/.env
docker stack deploy -c wordpress/compose.yml wordpress
echo "WordPress deployed."

# Deploy Semaphore for Ansible CI/CD
echo "Deploying Semaphore..."
docker stack deploy -c semaphore/docker-compose.yml semaphore
echo "Semaphore deployed."

# Print deployment status
echo "All specified services have been deployed successfully."

set +a
