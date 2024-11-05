#!/bin/bash

docker stack rm backup
set -a
source .env
docker stack deploy -c compose.yml --detach=true backup
set +a
