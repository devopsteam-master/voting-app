# Backup Server

This directory contains Docker Compose files and configurations for setting up a backup server using Restic for scheduled backups, pruning, and integrity checks.

## Configuration

Before deploying the backup server, ensure you have the following configurations set up:

1. **Restic Repository**: Define the location of the Restic repository where backups will be stored. Update the `RESTIC_REPOSITORY` variable in the `.env` file with the desired repository location.

2. **Access Credentials**: Provide the necessary credentials to access the backup storage (e.g., Minio). Update the `MINIO_BACKUP_USER` and `MINIO_BACKUP_PASSWORD` variables in the `.env` file with the appropriate access credentials.

3. **Restic Password**: Set a password for accessing the Restic repository. Update the `RESTIC_PASSWORD` variable in the `.env` file with a strong password.

## Usage

To use the backup server:

1. **Prepare Environment**: Make sure you have Docker installed on your system. Create a `.env` file in the same directory as the `docker-compose.yml` file and add the necessary environment variables as described above.

2. **Deploy Services**: Run the following command to deploy the backup services:

   ```bash
   docker stack deploy -c docker-compose.yml backup-server
   ```

   This command will deploy the backup server stack using Docker Swarm.

3. **Verify Deployment**: After deployment, verify that the services are running correctly by checking their logs:

   ```bash
   docker service logs backup-server_backup
   docker service logs backup-server_prune
   docker service logs backup-server_check
   ```

4. **Monitor Backups**: Monitor the backup status and logs using tools like Prometheus and Grafana, if configured.

5. **Modify Configuration (Optional)**: If needed, you can modify the backup schedule, retention policy, or other configurations by updating the environment variables in the `.env` file and redeploying the services.

6. **Cleanup (Optional)**: To remove the backup server stack and associated resources, run:

   ```bash
   docker stack rm backup-server
   ```
