# Ansible Directory

This directory contains Ansible playbooks and roles for automating various tasks related to system configuration, hardening, Docker container management, and Semaphore integration.

## Hardening

The `Hardening` directory focuses on system hardening tasks to ensure servers are configured securely. It includes playbooks and roles for:

- Configuring DNS, firewall settings, SSH, NTP, and system parameters.
- Running security audits with Lynis.

## Docker

The `Docker` directory manages Docker containers and environments using Ansible. It includes playbooks for:

- Managing Docker Compose deployments.
- Managing Docker containers directly.
- Specific Docker-related tasks.

## Semaphore

The `Semaphore` directory contains configuration files for setting up the Semaphore continuous integration and deployment platform in a Docker environment. It includes a `docker-compose.yml` file for orchestrating the Semaphore services.

## Usage

### Ansible Playbooks and Roles

To use the playbooks and roles in this directory:

1. Ensure Ansible is installed on your system.
2. Navigate to the desired playbook or role directory.
3. Adjust variables and settings as needed in the playbook or role files.
4. Execute the playbook using the `ansible-playbook` command, specifying the appropriate playbook file.

For example:
```bash
ansible-playbook -i inventory.yml hardening-playbook.yml
```

### Semaphore Setup with Docker Stack

To set up Semaphore using Docker stack:

1. Navigate to the `semaphore` directory.
2. Execute the following command to deploy Semaphore using Docker stack:
   ```bash
   docker stack deploy -c docker-compose.yml semaphore
   ```

## Contributing

Contributions to this Ansible directory are welcome! If you find bugs or have suggestions for improvements, please open an issue or submit a pull request.
