#!/bin/bash
docker stack rm wordpress
set -a
source .env

# Deploy the MariaDB Docker stack
docker stack deploy -c compose.yml --detach=true wordpress

# Disable automatic export of variables
set +a

