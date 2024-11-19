#!/bin/bash
docker stack rm gitlab
set -a
source .env
docker stack deploy -c compose.yml --detach=true gitlab
set +a
