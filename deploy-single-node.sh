#!/bin/bash
set -a

NETWORKS="traefik-net redis pg_net prometheus minio"
for i in $NETWORKS
do 
  docker network create --attachable=true --driver=overlay $i
done

source traefik/.env
docker stack deploy -c traefik/docker-compose.yml --detach=true traefik

source postgres/.env
docker stack deploy -c postgres/docker-compose-single-node.yml --detach=true pg

source redis/.env
docker stack deploy -c redis/docker-compose.yml --detach=true redis

source .env
docker stack deploy -c docker-compose.yml --with-registry-auth --resolve-image always --detach=true app

source minio/.env
docker stack deploy -c minio/docker-compose-single-node.yml --detach=true minio

source monlog/mimir/.env
docker stack deploy -c monlog/mimir/docker-compose-single-node.yml --detach=true mimir

source monlog/.env
docker stack deploy -c monlog/docker-compose.yml --detach=true monlog
docker stack deploy -c monlog/exporter-compose.yml --detach=true exporter

source backup-server/.env
docker stack deploy -c backup-server/docker-compose.yml --detach=true bu

set +a
