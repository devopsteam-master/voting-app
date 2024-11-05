#!/bin/bash

docker stack rm traefik 
set -a
source .env
docker stack deploy -c compose.yml traefik 
set +a