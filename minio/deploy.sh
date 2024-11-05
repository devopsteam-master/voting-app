#!/bin/bash

docker stack rm minio

set -a
source .env
docker stack deploy -c compose.yml --detach=true minio
set +a
