# Ansible Directory Overview

This directory contains Ansible configurations, playbooks, roles, and inventory for managing and automating the infrastructure. It is structured to provide clear separation between different aspects of the infrastructure automation, making it easier to manage and understand.

## Configuration

- **ansible.cfg**: This is the main Ansible configuration file. It defines global settings that affect all playbooks and roles, such as the inventory file location, default remote user, SSH connection settings, and performance options.

## Playbooks

Ansible playbooks are YAML files that describe the automation, configuration, deployment, and orchestration tasks to be performed on managed nodes.

- **hardening-playbook.yml**: Applies security hardening configurations across all hosts.
- **docker-playbook.yml**: Installs Docker and configures Docker daemon settings on all hosts.

## Inventory

- **inventory.yml**: Defines the groups of hosts and their variables. This file lists all the machines in your infrastructure and groups them for targeted automation tasks.

## Roles

Roles are units of organization in Ansible, allowing you to abstract and encapsulate sets of tasks, variables, files, and templates for easy reuse.

- **hardening**: Contains tasks, handlers, defaults, files, and metadata for applying security hardening measures to hosts. It includes configurations for SSH, NTP, sysctl, firewalld, DNS settings, and running Lynis audits.

### Role Structure

Each role typically contains the following directories:

- **tasks/**: Main list of tasks to be executed by the role.
- **handlers/**: Handlers, which are tasks that are only run when notified by another task.
- **defaults/**: Default variables for the role.
- **files/**: Contains static files which can be deployed via this role.
- **meta/**: Metadata about the role, including dependencies.

### Key Role Files

- **tasks/main.yml**: The entry point for the tasks in the role.
- **handlers/main.yml**: Contains handlers, which are tasks triggered by other tasks.
- **defaults/main.yml**: Defines default variables for the role.
- **meta/main.yml**: Provides metadata about the role, such as dependencies.

## Getting Started

To run a playbook, ensure you have Ansible installed and configured according to the `ansible.cfg` file. Then, execute a playbook using the ansible-playbook command. For example:

```bash
ansible-playbook playbooks/hardening-playbook.yml