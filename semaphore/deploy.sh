#!/bin/bash
docker stack rm semaphore
set -a
source .env
docker stack deploy -c docker-compose.yml --detach=true semaphore
set +a
