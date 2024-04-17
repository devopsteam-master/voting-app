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

   # Disaster Recovery Plan 


This Docker Compose configuration is designed to facilitate disaster recovery by restoring data from a backup repository using the Restic backup tool. It leverages the provided image mazzolino/restic to perform the restoration process.

Components:

1. **Restore Service (restore):**

Image: mazzolino/restic
Environment Variables:
RESTIC_REPOSITORY: The location of the Restic repository containing backup data.
RESTIC_PASSWORD: The password for accessing the Restic repository.
RESTIC_RESTORE_SOURCES: The directory or path in the backup repository from which data will be restored.
TZ: Timezone setting, used for timestamping operations.
AWS_ACCESS_KEY_ID: Access key ID for accessing the backup storage (e.g., MinIO).
AWS_SECRET_ACCESS_KEY: Secret access key for accessing the backup storage.

**Volumes:**
./data/restore:/mnt/volumes: Mounts a local directory (./data/restore) to /mnt/volumes inside the container, where restored data will be placed.

**Networks:**
minio: Connects the service to a network named minio, which is assumed to be the network where the backup storage (e.g., MinIO) is accessible.

**Entrypoint and Command:**

Sets the entrypoint to /bin/sh -c.
Executes the Restic command to restore the latest backup from the repository to the specified target directory.

2. **External Network (minio):**

This configuration assumes the existence of an external network named minio, which is used to connect the restore service to the backup storage service (e.g., MinIO). Please ensure that this network is properly configured and accessible before deploying the Compose stack.

## Usage

1. Ensure that the backup repository (RESTIC_REPOSITORY) and associated credentials (RESTIC_PASSWORD, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) are correctly configured and accessible.

2. Place the data to be restored in the appropriate location within the backup repository.

3. Update the RESTIC_RESTORE_SOURCES environment variable to point to the directory or path within the backup repository containing the data to be restored.

4. Deploy the Docker Compose stack using the provided configuration:

```bash
 docker-compose up -d
```

5. Monitor the restoration process using Docker logs:

```bash
docker-compose logs -f restore
```

6. Once the restoration process is complete, verify that the data has been successfully restored to the target directory (./data/restore in this example).

**Important Notes:**

Ensure that the backup repository and associated storage (e.g., MinIO) are properly configured and accessible before initiating the restoration process.

Review and update the environment variables and paths according to your specific backup and restoration requirements.

Monitor the restoration process closely to ensure that it completes successfully and verify the integrity of the restored data.
