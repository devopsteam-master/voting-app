# MariaDB Galera Cluster Deployment Guide

This guide provides step-by-step instructions to deploy and manage a MariaDB Galera Cluster using Docker Compose. By following these steps, team members should be able to initialize the cluster, add nodes, and handle node restarts as needed.

## Prerequisites

- Ensure Docker and Docker Compose are installed on all nodes.
- Access to Docker Swarm for managing deployments across multiple nodes.

## Deployment Steps

### 1. Prepare the `.env` File

Create a `.env` file with the following environment variables:

```dotenv
MARIADB_ROOT_PASSWORD=SecureRootPass!23
MARIADB_GALERA_CLUSTER_NAME=production_galera_cluster
MARIADB_GALERA_MARIABACKUP_USER=backupAdmin
MARIADB_GALERA_MARIABACKUP_PASSWORD=SecureBackupPass!98
MARIADB_USER=prod_user
MARIADB_PASSWORD=ProdUserPass!56
MARIADB_DATABASE=production_db
```

> **Note**: Do not include `MARIADB_GALERA_CLUSTER_ADDRESS` in the `.env` file, as it will be set directly in `docker-compose.yml` to manage different nodes correctly.

### 2. Initial Bootstrap of `galera-node1`

For the first deployment, set the replicas in `docker-compose.yml` as follows:
```yaml
galera-node1:
  deploy:
    replicas: 1
galera-node2:
  deploy:
    replicas: 0
galera-node3:
  deploy:
    replicas: 0
```

**Ensure** the following variables are set correctly in `docker-compose.yml` for `galera-node1`:
- `MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://`
- `MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes`  *(this variable enables bootstrapping the cluster for the first node only)*

### 3. Deploying the Cluster with `deploy.sh`

To deploy the cluster, use the `deploy.sh` script provided below. This script will remove any existing deployment of the MariaDB stack, source the environment variables, and deploy the stack in Docker Swarm.

#### `deploy.sh` Script

```bash
#!/bin/bash
docker stack rm mariadb
set -a
source .env

# Deploy the MariaDB Docker stack
docker stack deploy -c compose.yml --detach=true mariadb

# Disable automatic export of variables
set +a
```

#### Running the Script

To deploy the cluster, simply run:

```bash
chmod +x deploy.sh
./deploy.sh
```

This script will:
1. Remove any existing deployment of the MariaDB stack.
2. Load environment variables from `.env`.
3. Deploy the MariaDB stack in Docker Swarm.

### 4. Adding Nodes (`galera-node2` and `galera-node3`)

Once `galera-node1` is up and running, scale up the replicas for `galera-node2` and `galera-node3` to 1 by modifying `docker-compose.yml`:

```yaml
galera-node2:
  deploy:
    replicas: 1
galera-node3:
  deploy:
    replicas: 1
```

For both `galera-node2` and `galera-node3`, ensure the following in `docker-compose.yml`:
- `MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://galera-node1,galera-node2,galera-node3`
- **Do not set** `MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes` for these nodes.

Redeploy the stack to bring up the additional nodes:
```bash
./deploy.sh
```

### 5. Rejoining `galera-node1` After Shutdown

If `galera-node1` stops or is shut down, follow these steps to rejoin it to the cluster:

1. **Remove the Bootstrap Flag**: Comment out or remove `MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes` in `docker-compose.yml` for `galera-node1`.
   
2. **Update Cluster Address**: Change `MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://` to:
   ```yaml
   MARIADB_GALERA_CLUSTER_ADDRESS=gcomm://galera-node1,galera-node2,galera-node3
   ```

3. **Restart the Stack**: With these changes saved, restart the stack using:
   ```bash
   ./deploy.sh
   ```

### 6. Rejoining `galera-node2` and `galera-node3` After Shutdown

If `galera-node2` or `galera-node3` stops or is shut down, they can be rejoined to the cluster without modifying any environment variables or configuration. Simply redeploy the stack as usual:

```bash
./deploy.sh
```

These nodes will automatically rejoin the cluster as long as `galera-node1` is running and stable.

## Additional Tips

- **Check Cluster Status**: Use `docker logs <container_id> | grep "WSREP"` to check each node's cluster state.
- **Cluster Consistency**: Always start by bootstrapping `galera-node1`. Only add nodes after confirming `galera-node1` is stable.
- **Scaling**: Ensure that nodes are scaled in the correct order. Avoid setting `MARIADB_GALERA_FORCE_SAFETOBOOTSTRAP=yes` on more than one node at a time.

Following this guide will help ensure the Galera Cluster is deployed, managed, and scaled effectively in a Docker Swarm environment.