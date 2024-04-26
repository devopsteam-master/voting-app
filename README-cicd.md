# CI/CD Pipeline Overview

This document provides an overview of the Continuous Integration/Continuous Deployment (CI/CD) pipeline as defined in the `.gitlab-ci.yml` file for the Monster project. The CI/CD pipeline is designed to automate the process of building, testing, and deploying the application components to various environments.

## Pipeline Stages

The pipeline is divided into several stages that are executed in sequence:

1. **Build**: Compiles the application, builds Docker images for the voting app components (vote, worker, result), and pushes them to a Docker registry.
2. **Test**: Pulls the Docker images, runs tests using Docker Compose, and pushes the latest tags if the tests pass.
3. **Deploy**: Deploys the application to pre-production or production environments based on manual triggers or successful completion of previous stages.

## Key Components

- **Docker in Docker (DinD)**: Used as the base image to allow Docker commands within GitLab CI jobs.
- **Container Scanning**: Utilizes GitLab's Container Scanning template to scan the built Docker images for vulnerabilities.
- **Environment Variables**: Defined for Docker registry credentials, image paths, and deployment configurations.

## Jobs

### Build Jobs

- `job-vote`, `job-worker`, `job-result`: Build Docker images for each component of the voting app and push them to the Docker registry.

### Test Job

- `job-test`: Pulls the Docker images for the voting app components, runs tests using Docker Compose, and pushes the `latest` tags for each image upon successful test completion.

### Container Scanning Jobs

- `container_scanning`, `container_scanning_worker`, `container_scanning_result`: Extend the `container_scanning` job to scan each component's Docker image for vulnerabilities. These jobs are triggered manually.

### Deployment Jobs

- `deploy-to-preproduction`: Deploys the application to a pre-production environment. It is triggered automatically after successful test completion.
- `deploy-to-production`: Deploys the application to the production environment. This job requires a manual trigger.

## Deployment Process

The deployment process involves transferring necessary files to the target server, configuring the environment, and executing deployment scripts. It supports deploying to both pre-production and production environments with configurations specified for each.

## Usage

To trigger the pipeline, push changes to the repository or manually trigger the desired jobs through the GitLab UI. For deployment jobs, ensure that the necessary SSH keys and environment variables are configured in the GitLab project settings.
