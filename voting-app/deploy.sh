#!/bin/bash

docker stack rm vote-stack

docker stack rm redis

docker stack rm postgres-stack

set -a

NETWORKS="pg_net redis"
for i in $NETWORKS
do 
  docker network create --attachable=true --driver=overlay $i
done

source postgres/.env
docker stack deploy -c postgres/docker-compose.yml --detach=true postgres-stack

echo "Waiting 60 seconds for Postgres to initialize..."
sleep 60

source redis/.env
docker stack deploy -c redis/docker-compose.yml --detach=true redis

echo "Waiting 15 seconds for Redis to initialize..."
sleep 15

source .env
docker stack deploy -c docker-compose.yml --detach=true vote-stack

set +a
