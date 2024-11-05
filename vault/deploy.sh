#!/bin/bash
docker stack rm vault
set -a
source .env
docker stack deploy -c docker-compose.yml --detach=true vault
set +a
