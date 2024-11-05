#!/bin/bash
docker stack rm mariadb
set -a
source .env

# Deploy the MariaDB Docker stack
docker stack deploy -c compose.yml --detach=true mariadb

# Disable automatic export of variables
set +a

