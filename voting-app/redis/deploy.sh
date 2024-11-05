#!/bin/bash

docker stack rm redis

set -a
source .env
docker stack deploy -c docker-compose.yml --detach=true redis
set +a
