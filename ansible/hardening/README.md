# Ansible Hardening Project

## Overview

This Ansible project is designed to harden servers, configure essential services, and automate deployment of infrastructure components. This setup includes hardening configurations, Docker installation, Nexus repository setup, Traefik load balancer configuration, and VM provisioning in vCenter

The project aims to:
- Ensure system security by applying hardening configurations.
- Automate Docker installation and configuration.
- Deploy and configure Traefik and Nexus on target servers.
- Manage and create virtual machines in vCenter for infrastructure expansion.

## Project Structure

```plaintext
.
├── ansible.cfg                  # Ansible configuration file
├── inventory                    # Hosts and variables directory
│   ├── group_vars               # Variables for groups of hosts
│   ├── hosts.yml                # Inventory file for host definitions
│   └── host_vars                # Variables specific to individual hosts
├── mitogen                      # Mitogen plugin for performance optimization
├── playbook.yml                 # Main Ansible playbook
├── README.md                    # Project documentation
└── roles                        # Roles directory containing individual components
    ├── docker                   # Role to install and configure Docker
    ├── harden                   # Role to harden the server and apply security policies
    ├── host                     # Role to create and manage VMs on vCenter
    ├── nexus                    # Role to deploy and configure Nexus repository
    └── traefik                  # Role to deploy and configure Traefik load balancer
```

## Role Descriptions

1. **Docker**: Installs Docker and manages configurations.
   - **Tasks**: `install-docker.yml`, `main.yml`
   - **Files**: Docker override configurations.
   
2. **Harden**: Applies system hardening configurations using tools like Lynis to achieve a security score of 80+.
   - **Tasks**: Configures SSH, Fail2ban, AuditD, IP tables, kernel parameters, password policies, and more.
   - **Templates**: Config files for Fail2ban, IP tables, and SSH hardening.

3. **Host**: Manages VM creation in vCenter and configures network settings.
   - **Tasks**: Creates VMs and applies initial configurations.

4. **Nexus**: Deploys and configures Nexus using Docker Compose.
   - **Tasks**: Copies Docker Compose file, starts Nexus service, and manages Nexus environment variables.
   
5. **Traefik**: Configures Traefik as a reverse proxy and load balancer.
   - **Tasks**: Deploys Docker Compose file, configures Traefik with ACME (Let's Encrypt) for SSL.

## Inventory Setup

The inventory is managed in `inventory/hosts.yml`, where you define the target servers and their roles.

Example structure of `hosts.yml`:

```yaml
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3
  children:
    webservers:
      hosts:
        harden-server1:
          ansible_host: Host-IP
          ansible_user: UserName
          ansible_port: Port
        harden-server2:
          ansible_host: Host-IP
          ansible_user: User
          ansible_port: port
    dbservers:
      hosts:
        harden-server3:
          ansible_host: Host-IP
          ansible_user: UserName
          ansible_port: Port
```

## Configuration Files

### `ansible.cfg`

Ansible configuration is managed in `ansible.cfg`. Key settings include:
- **Inventory File**: Points to `inventory/hosts.yml`.
- **Mitogen**: Enables the Mitogen plugin for faster task execution.
- **SSH Connection Options**: Configures persistent connections with multiple retries.

### Group Variables (`group_vars/`) and Host Variables (`host_vars/`)

Organize variables specific to groups of hosts or individual hosts. You can add group variables under `group_vars/` and individual host variables in `host_vars/`.

## Playbook Execution

The main playbook (`playbook.yml`) defines the roles and tasks to be executed on the target servers:

```yaml
---
- name: Hardening and Service Deployment
  hosts: all
  gather_facts: true
  become: true
  roles:
    - role: harden      # Applies server hardening configurations
    - role: traefik     # Deploys and configures Traefik
    - role: nexus       # Deploys and configures Nexus
    - role: host        # Manages VM creation on vCenter
    - role: docker      # Installs and configures Docker
```

### Running the Playbook

To execute the playbook, navigate to the project directory and run:

```bash
ansible-playbook playbook.yml
```

## Deployment Steps

1. **Set Up Inventory**:
   - Edit `inventory/hosts.yml` to define your target hosts.
   
2. **Configure Variables**:
   - Update variables in `group_vars/` and `host_vars/` as needed for your environment.

3. **Execute the Playbook**:
   - Run the playbook using `ansible-playbook playbook.yml`.

## Role Details

### Harden Role

The `harden` role applies various security configurations, including:
- **SSH Hardening**: Configures SSHD settings.
- **Firewall Rules**: Manages IP tables and firewall settings.
- **System Policies**: Applies secure password policies and kernel parameters.

### Docker Role

The `docker` role installs Docker and configures it according to best practices, ensuring it's ready to deploy other services in containers.

### Nexus Role

The `nexus` role deploys Nexus using Docker Compose. It configures Nexus with environment variables, manages Docker Compose files, and ensures Nexus starts automatically.

### Traefik Role

The `traefik` role configures Traefik as a reverse proxy with SSL support using Let's Encrypt ACME. It also includes basic security headers and redirect configurations.

## Additional Configuration (Traefik)

The `traefik` role uses `config.yml` for middleware configurations, such as security headers and HSTS policies. 

Example of `config.yml`:

```yaml
http:
  middlewares:
    redirect:
      redirectScheme:
        scheme: https

    security:
      headers:
        frameDeny: true
        referrerPolicy: true
        contentSecurityPolicy: true
        contentTypeNosniff: true
        browserXssFilter: true

    hsts:
      headers:
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        sslRedirect: true
        stsPreload: true
        forceSTSHeader: true
```

## Notes

- **Mitogen**: This setup uses the Mitogen plugin for enhanced performance. Ensure it's properly installed and configured in `ansible.cfg`.
- **Customizing Roles**: Each role can be customized in its respective `vars/main.yml` file for specific configuration needs.
- **Sensitive Information**: Keep `.env` files secure, as they contain sensitive information such as passwords and access tokens.

## Troubleshooting

- **Connection Issues**: Ensure that SSH keys and user permissions are correctly configured in `hosts.yml`.
- **Role Errors**: If a role fails, check the relevant role's `README.md` and verify the configuration settings in `group_vars` or `host_vars`.
- **Logs**: Enable debug logs by adding `-vvv` to the `ansible-playbook` command for detailed troubleshooting information.

