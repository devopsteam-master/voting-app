#!/bin/bash

docker stack rm postgres-stack

set -a
source .env
docker stack deploy -c docker-compose.yml --detach=true postgres-stack
set +a
