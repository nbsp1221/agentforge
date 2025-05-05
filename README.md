# n8n with PostgreSQL

This setup allows you to run n8n with a PostgreSQL database using Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Setup Instructions

1. Create a directory for files that will be accessible by n8n:

```bash
mkdir -p files
```

2. Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit the `.env` file to set your database credentials and other configuration options.

3. Create an external network for Caddy:

```bash
docker network create caddy-network
```

4. Start the containers:

```bash
docker compose up -d
```

5. Access n8n through your browser at:

```
http://localhost:5678
```

## Stopping the Service

To stop the containers:

```bash
docker compose down
```

## Upgrading n8n

To upgrade to the latest version:

```bash
# Pull latest version
docker compose pull

# Stop and remove older version
docker compose down

# Start the container
docker compose up -d
```

## Environment Variables

The following important environment variables can be configured in your `.env` file:

### PostgreSQL Configuration
- `POSTGRES_DB`: Name of the PostgreSQL database (default: n8n)
- `POSTGRES_USER`: PostgreSQL root username
- `POSTGRES_PASSWORD`: PostgreSQL root password
- `POSTGRES_NON_ROOT_USER`: Non-root username for n8n to connect
- `POSTGRES_NON_ROOT_PASSWORD`: Non-root user password

### n8n Configuration
- `N8N_PROTOCOL`: Protocol to use (http or https)
- `N8N_HOST`: Hostname for n8n
- `WEBHOOK_URL`: URL for webhooks
- `GENERIC_TIMEZONE`: Timezone for n8n to use (UTC, Europe/Berlin, etc.)

## Important Notes

- The `init-db.sh` script creates a non-root PostgreSQL user for n8n to connect with.
- All n8n data is stored in Docker volumes for persistence.
- You can place files you want to access from n8n in the `./files` directory, which is mounted to `/files` in the n8n container.
- This setup uses an external `caddy-network` which should be created before running the containers.
