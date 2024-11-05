# Traefik Deployment Guide

This guide provides instructions for deploying and configuring Traefik as a reverse proxy and load balancer within our Docker Swarm environment. Traefik handles routing, SSL termination, and basic access control for various services within our setup.

## Table of Contents

1. [Overview](#overview)
2. [Environment Variables](#environment-variables)
3. [Project Structure](#project-structure)
4. [Deployment Steps](#deployment-steps)
5. [Traefik Configuration](#traefik-configuration)
6. [Service Routing](#service-routing)
7. [Security Configuration](#security-configuration)
8. [Additional Notes on Services](#additional-notes-on-services)

---

## Overview

Traefik is configured to handle HTTP(S) requests and route them to various internal services based on subdomains. It uses Let’s Encrypt for automatic SSL certificate management, ensuring secure HTTPS connections for all exposed services. This deployment is ideal for a microservices architecture, simplifying traffic management and security policies.

## Environment Variables

The `.env` file is used to configure key variables for Traefik and the services it manages.

```plaintext
# Domain address
DOMAIN_NAME=YourDomain Address
TRAEFIK_SUB_DOMAIN=SubDomain

# ACME email for Let's Encrypt
TRAEFIK_ACME_EMAIL=noreply@gmail.com

# Basic authentication for the Traefik dashboard
WEB_AUTH_USER=UserName
WEB_AUTH_PASS="HashedPassword"

# Docker service configurations
RESTART_POLICY=on-failure
HOST_NAME=node1
```

> **Note:** The `WEB_AUTH_PASS` is an SHA-encrypted password. You can generate it with the following command:
> ```bash
> docker run --rm xmartlabs/htpasswd -s <username> <password>
> ```

## Project Structure

```plaintext
.
├── .env                   # Environment variables
├── deploy.sh              # Script to deploy Traefik
├── compose.yml            # Docker Compose configuration for Traefik
└── config/
    └── tr.yml             # Traefik security and middleware configuration
```

### Files Overview

- **.env**: Contains configurable environment variables for domain, authentication, and ACME email.
- **deploy.sh**: Script to deploy the Traefik stack.
- **compose.yml**: Defines Traefik service configuration, networks, volumes, and labels.
- **config/tr.yml**: Traefik configuration file for security headers, HSTS, and TLS settings.

## Deployment Steps

1. **Set Up Environment Variables**: Ensure all required environment variables are set in `.env`.

2. **Deploy Traefik**: Run the `deploy.sh` script to deploy Traefik using Docker Compose.

   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Verify Deployment**: After deployment, you can access the Traefik dashboard by visiting `https://<TRAEFIK_SUB_DOMAIN>.<DOMAIN_NAME>`. Use the credentials specified in `.env` to log in.

---

## Traefik Configuration

The Traefik service is defined in `compose.yml` with the following key settings:

- **Log Level**: Set to `DEBUG` to capture detailed logs.
- **ACME (Let’s Encrypt)**: Automatically manages SSL certificates for secure HTTPS connections.
- **API and Dashboard**: The dashboard is available at `https://web.<DOMAIN_NAME>`, secured with basic authentication.
- **Entry Points**: Configures HTTP (port 80), HTTPS (port 443), and metrics (port 8082).

---
## Service Routing

Traefik routes traffic to the various services deployed within our infrastructure based on the subdomain and path rules defined in the configuration. Here’s a breakdown of the routing setup for each service on the `YourDomain Address` domain:

1. **API and Internal Dashboard**
   - **API**: Accessible via `PathPrefix(/api)` on the `traefik` entry point, routed to `api@internal`.
   - **Dashboard**: Accessible via `PathPrefix(/)` on the `traefik` entry point, routed to `dashboard@internal`.

2. **HAProxy**
   - **HTTPS**: `https://haproxy.YourDomain Address` routed to `haproxy-secure@swarm`.
   - **HTTP**: `http://haproxy.YourDomain Address` routed to `haproxy@swarm`.
   - **Priority**: 32.

3. **MinIO**
   - **HTTPS**: `https://minio.YourDomain Address` routed to `minio-secure@swarm`.
   - **HTTP**: `http://minio.YourDomain Address` routed to `minio@swarm`.
   - **Priority**: 30.

4. **Metrics**
   - **Prometheus Metrics**: Available via `PathPrefix(/metrics)` on the `metrics` entry point, routed to `prometheus@internal`.
   - **Service Metrics**: Available on both `http` and `https` entry points with `PathPrefix(/)`, routed to `my-service@swarm` (associated with the `result` service).

5. **Result Service**
   - **HTTPS**: `https://result.YourDomain Address` routed to `result-secure@swarm`.
   - **HTTP**: `http://result.YourDomain Address` routed to `result@swarm`.
   - **Priority**: 31.

6. **Sema Service**
   - **HTTPS**: `https://sema.YourDomain Address` routed to `sema-secure@swarm`.
   - **HTTP**: `http://sema.YourDomain Address` routed to `sema@swarm`.
   - **Priority**: 29.

7. **Traefik Dashboard**
   - **HTTPS**: `https://web.YourDomain Address` routed to `traefik-secure@swarm`.
   - **HTTP**: `http://web.YourDomain Address` routed to `traefik@swarm`.
   - **Priority**: 28.

8. **Vaultwarden (Password Management)**
   - **HTTPS**: `https://vault.YourDomain Address` routed to `vaultwarden@swarm`.
   - **Priority**: 30.

9. **Vote Service**
   - **HTTPS**: `https://vote.YourDomain Address` routed to `vote-secure@swarm`.
   - **HTTP**: `http://vote.YourDomain Address` routed to `vote@swarm`.
   - **Priority**: 29.

10. **WordPress**
    - **HTTPS**: `https://wp.YourDomain Address` routed to `wordpress-secure@swarm`.
    - **HTTP**: `http://wp.YourDomain Address` routed to `wordpress@swarm`.
    - **Priority**: 27.

Each service is configured with HTTPS redirection, and TLS certificates are managed automatically by Traefik with Let’s Encrypt. The secure versions of the services are assigned with middlewares for enhanced security headers (configured in `config/tr.yml`).

---

## Security Configuration

Security policies are implemented in `config/tr.yml`, with the following features:

- **HTTPS Redirection**: Ensures all HTTP traffic is redirected to HTTPS.
- **Strict Transport Security (HSTS)**: Enforces a 1-year HTTPS policy with preload and subdomain inclusion.
- **Content Security Policy**: Restricts content sources to prevent XSS attacks.
- **X-Frame-Options and X-Content-Type-Options**: Mitigate common security risks by preventing clickjacking and MIME type sniffing.

These settings help secure the various services managed by Traefik, providing an added layer of protection.

---

## Troubleshooting

1. **Access Issues**: Verify DNS and subdomain configuration in your environment. Each subdomain should point to the appropriate Traefik instance.
2. **Certificate Issues**: Ensure ACME email and domain information in `.env` is correct for Let’s Encrypt to issue SSL certificates.
3. **Service Unavailable**: Check that the service is deployed and running. Use `docker service ls` to verify service status.
