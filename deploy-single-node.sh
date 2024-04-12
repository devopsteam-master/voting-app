#!/bin/bash
set -a
NETWORKS="traefik-net redis pg_net prometheus minio"
for i in $NETWORKS
do 
  docker network create --driver=overlay $i
done

source traefik/.env
docker stack deploy -c traefik/docker-compose.yml traefik

source voting-app/postgres/.env
docker stack deploy -c voting-app/postgres/docker-compose-single-node.yml pg

source voting-app/redis/.env
docker stack deploy -c voting-app/redis/docker-compose.yml redis

source voting-app/.env
docker stack deploy -c voting-app/docker-compose.yml app

source minio/.env
docker stack deploy -c minio/docker-compose-single-node.yml minio

source monlog/mimir/.env
docker stack deploy -c monlog/mimir/docker-compose-single-node.yml mimir

source monlog/.env
docker stack deploy -c monlog/docker-compose.yml monlog
docker stack deploy -c monlog/exporter-compose.yml exporter

source backup-server/.env
docker stack deploy -c backup-server/docker-compose.yml bu

set +a
