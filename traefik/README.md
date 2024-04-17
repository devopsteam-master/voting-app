# Traefik

Traefik is a modern reverse proxy and load balancer. This directory contains configurations for deploying Traefik in a Docker Swarm cluster.

## Deployment

1. Ensure you have Docker Swarm set up.
2. Navigate to the "traefik" directory.
3. Copy the `.env.example` file to `.env` and configure the following environment variables:

```bash
# Domain address
DOMAIN=<your_domain>
TRAEFIK_SUB=<subdomain>

# ACME variables
ACME_EMAIL=<your_email_address>

# Web auth information
# Generate password with: `docker run --rm xmartlabs/htpasswd -s username password`
WEB_AUTH_USER=<username>
WEB_AUTH_PASS=<hashed_password>
```

4. Deploy Traefik using Docker Stack:

```bash
docker stack deploy -c docker-compose.yml traefik
```

## Configuration

### Domain Configuration

Set the `DOMAIN` variable to your domain address, e.g., `DOMAIN=mydomain.com`.

### Subdomain Configuration

Set the `TRAEFIK_SUB` variable to your desired subdomain, e.g., `TRAEFIK_SUB=web`.

### ACME Email

Set the `ACME_EMAIL` variable to your email address for Let's Encrypt certificate notifications.

### Web Auth Credentials

1. Generate a password hash using the following command:

```bash
docker run --rm xmartlabs/htpasswd -s <username> <password>
```

2. Replace `<username>` with your desired username and `<password>` with your desired password. Replace `<hashed_password>` with the output of the command.

3. Set the `WEB_AUTH_USER` variable to your username and `WEB_AUTH_PASS` variable to the hashed password.