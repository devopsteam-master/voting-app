#!/bin/bash

docker stack rm postgres-stack

set -a
source .env
docker stack deploy -c compose.yml --detach=true postgres-stack
set +a
