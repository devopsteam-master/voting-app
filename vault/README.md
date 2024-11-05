# Vaultwarden Deployment Guide

Vaultwarden is a self-hosted password management solution that provides a secure way to manage and share passwords, secrets, and other sensitive data. It is a lightweight alternative to Bitwarden and can be easily deployed with Docker, making it an ideal choice for secure password management in our DevOps environment.

This guide explains how to deploy Vaultwarden, configure it with Traefik for SSL, and set up SMTP for email notifications. By following these instructions, new team members should be able to set up and use Vaultwarden in our environment.

---

## Table of Contents

1. [What is Vaultwarden?](#what-is-vaultwarden)
2. [Environment Variables](#environment-variables)
3. [Project Structure](#project-structure)
4. [Deployment Steps](#deployment-steps)
5. [Using Vaultwarden](#using-vaultwarden)
6. [SMTP Configuration for Email Notifications](#smtp-configuration-for-email-notifications)

---

## What is Vaultwarden?

Vaultwarden is a self-hosted server that serves as a secure and reliable password management tool. It is a lightweight implementation of the Bitwarden API, allowing you to manage passwords, notes, and other sensitive information. With Vaultwarden, we can:

- Store and share passwords securely within the team.
- Access Vaultwarden through a web interface with HTTPS, managed by Traefik.
- Enable email notifications for account activities using SMTP.

In this project, Vaultwarden is deployed in Docker and configured with Traefik to handle HTTPS and certificate management.

---

## Environment Variables

Create a `.env` file in the root of the project directory with the following environment variables:

```plaintext
# Main domain
DOMAIN=YourDomain
FULL_DOMAIN=http://vault.DomainAddress

# Subdomain for Vaultwarden
VAULT_SUBDOMAIN=vault

# Admin token for Vaultwarden (used to access the admin panel)
ADMIN_TOKEN=YourAdminPassword

# SMTP Configuration for email notifications
SMTP_USERNAME='noreply@gmail.com'
SMTP_PASSWORD='App Password For SMTP'
```

Replace values for `ADMIN_TOKEN`, `SMTP_USERNAME`, and `SMTP_PASSWORD` with your specific configuration if necessary.

---

## Project Structure

```plaintext
.
├── deploy.sh                 # Script to deploy Vaultwarden
├── docker-compose.yml        # Compose file defining the Vaultwarden service
└── .env                      # Environment file with necessary configurations
```

### Files Overview

- **deploy.sh**: Deployment script that loads environment variables and deploys Vaultwarden with Docker Compose.
- **docker-compose.yml**: Docker Compose file that defines the Vaultwarden service, along with Traefik labels and SMTP configuration.
- **.env**: Contains environment variables used for domain configuration, Vaultwarden, Traefik, and SMTP settings.

---

## Deployment Steps

1. **Ensure Docker and Docker Compose are Installed**: Make sure that Docker and Docker Compose are installed and properly configured on your system.

2. **Configure Environment Variables**: Copy the provided `.env` template and fill in your specific values.

3. **Deploy Vaultwarden**: Run the `deploy.sh` script to deploy Vaultwarden.
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

   This script will:
   - Remove any previous Vaultwarden deployment.
   - Source the environment variables from `.env`.
   - Deploy Vaultwarden with Docker Compose in detached mode.

4. **Verify Deployment**: Once deployed, Vaultwarden should be accessible at:
   ```plaintext
   https://vault.YourDomain Address
   ```

5. **Set Up Admin Access**: Use the `ADMIN_TOKEN` specified in `.env` to access the Vaultwarden admin panel. This will allow you to configure additional settings, manage users, and review logs.

---

## Using Vaultwarden

### Accessing the Vaultwarden Web Interface

After deployment, Vaultwarden will be available at `https://${VAULT_SUBDOMAIN}.${DOMAIN}`, which translates to:
```plaintext
https://vault.YourDomain Address
```

Log in or create a Vaultwarden account if it’s your first time accessing the system. Since this instance allows new signups (`SIGNUPS_ALLOWED=true`), team members can create accounts directly on this platform.

### Admin Access

To access the Vaultwarden admin panel, use the `ADMIN_TOKEN` set in your `.env` file. The admin panel enables you to:

- Monitor active sessions.
- Manage user accounts and permissions.
- Review and configure additional security settings.

### SMTP Configuration for Email Notifications

Vaultwarden is configured to use SMTP for email notifications (e.g., for new account signups, password resets, and other notifications). Ensure the SMTP settings in `.env` are correct, especially if using a Gmail account:

- **SMTP_HOST**: `'smtp.gmail.com'` (hardcoded in the `docker-compose.yml` file).
- **SMTP_PORT**: `587` for TLS.
- **SMTP_USERNAME** and **SMTP_PASSWORD**: Enter your email and generated app password for Gmail.

---

## Important Notes

- **SSL Certificates**: Traefik manages SSL certificates automatically through Let’s Encrypt using the `LETSENCRYPT_EMAIL` provided in the `.env` file.
- **Data Persistence**: Vaultwarden’s data is stored in the `vaultwarden-data` volume, ensuring persistence across restarts.
- **Security**: Only trusted team members should have access to the Vaultwarden admin panel (`ADMIN_TOKEN` is required).

---

## Troubleshooting

1. **Vaultwarden Not Accessible**:
   - Ensure Traefik is correctly configured and running.
   - Check that DNS settings for `vault.DomainAddress` are pointing to the server's IP address.

2. **SMTP Issues**:
   - Verify that `SMTP_USERNAME` and `SMTP_PASSWORD` are correct in `.env`.
   - If using Gmail, ensure that “Allow less secure app access” is enabled or use an app-specific password for enhanced security.

3. **SSL Certificate Errors**:
   - Ensure that `LETSENCRYPT_EMAIL` is set and that the domain is reachable over HTTP/HTTPS.
   - Verify that Traefik logs show successful certificate generation and no renewal errors.

Following this guide, you should be able to deploy, configure, and use Vaultwarden in our environment. For any additional configuration or troubleshooting, refer to Vaultwarden's [official documentation](https://github.com/dani-garcia/vaultwarden) or consult the team lead.
