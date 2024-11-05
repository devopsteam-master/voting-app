# WordPress Deployment with HAProxy and MariaDB Galera Cluster

This README provides a step-by-step guide to deploying WordPress in a Docker Swarm environment, using HAProxy for load balancing requests to a MariaDB Galera cluster.

## Prerequisites

1. **MariaDB Galera Cluster**: Ensure the MariaDB Galera Cluster is deployed and accessible via HAProxy, as described in the `mariadb/README.md`.
2. **Traefik**: Set up as a reverse proxy for routing HTTP/HTTPS traffic to WordPress.
3. **Environment Variables**: Create a `.env` file at the root of your project with the following variables:

   ```dotenv
   DOMAIN=YourDomain
   WP_SUB=YourSubDomain

   MYSQL_USER=your_user
   MYSQL_PASSWORD=your_password
   MYSQL_DATABASE=your_database
   MYSQL_ROOT_PASSWORD=your_root_password
   ```

   Replace the values with your actual configuration.

## Directory Structure

Your project structure should look like this:

```plaintext
.
├── compose.yml
├── deploy.sh
├── mariadb
│   ├── compose.yml
│   ├── deploy.sh
│   └── README.md
└── README.md
```

- **compose.yml**: Defines the WordPress service configuration.
- **deploy.sh**: Deploys the WordPress stack.
- **mariadb**: Contains the MariaDB cluster setup.

## WordPress Deployment

### Compose Configuration (compose.yml)

The `compose.yml` file for WordPress contains the following essential configurations:

- **Database Connection**: WordPress connects to MariaDB via HAProxy on port `3306` (specified as `proxy:3306` in `WORDPRESS_DB_HOST`).
- **Networking**: Uses two networks—`web_net` for Traefik and `internal-network` for internal services.
- **Traefik Labels**: Configures Traefik rules for routing HTTP/HTTPS traffic to the WordPress service.

### Deploy Script (deploy.sh)

The `deploy.sh` script simplifies deploying the WordPress stack by handling variable loading and Docker stack deployment.

#### `deploy.sh`

```bash
#!/bin/bash
docker stack rm wordpress
set -a
source .env

# Deploy the WordPress Docker stack
docker stack deploy -c compose.yml --detach=true wordpress

# Disable automatic export of variables
set +a
```

To deploy WordPress, simply run:
```bash
chmod +x deploy.sh
./deploy.sh
```

### Setting Up HAProxy for MySQL Traffic

Ensure HAProxy is configured to forward MySQL requests from WordPress to the MariaDB Galera Cluster. Add the following configuration in `haproxy.cfg`:

```plaintext
frontend mysql-frontend
  bind *:3306
  mode tcp
  default_backend mysql-backend

backend mysql-backend
  mode tcp
  balance roundrobin
  option tcp-check
  server node1 galera-node1:3306 maxconn 1024 check inter 1s resolvers docker init-addr last,libc,none
  server node2 galera-node2:3306 maxconn 1024 check inter 1s resolvers docker init-addr last,libc,none backup
  server node3 galera-node3:3306 maxconn 1024 check inter 1s resolvers docker init-addr last,libc,none backup
```

This configuration forwards requests from WordPress to `mysql-frontend`, balancing them across `galera-node1`, `galera-node2`, and `galera-node3`.

## Notes

1. **Service Order**: Ensure the MariaDB Galera Cluster is up and running before deploying WordPress.
2. **Accessing WordPress**: Once deployed, WordPress can be accessed at:
   ```
   http://wp.YourDomain Address
   ```
3. **Traefik Configuration**: The WordPress service is configured with Traefik labels to route traffic securely with HTTPS, applying middlewares for redirection.

## Additional Commands

- **Check Logs**: Use `docker service logs wordpress` to check the WordPress service logs.
- **Update Stack**: To update the WordPress stack after modifying `compose.yml`, run:
  ```bash
  ./deploy.sh
  ```

By following these steps, you should be able to deploy and access your WordPress site, connected to a MariaDB Galera cluster through HAProxy. This setup ensures reliable database access and high availability for production use.
