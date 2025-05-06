# AI Agents

A framework for building and deploying AI agents using n8n workflow automation and LiteLLM for standardized LLM access.

## Overview

This setup combines:
- **n8n**: Powerful workflow automation platform for building agent logic
- **LiteLLM**: Proxy server for standardized access to various LLM providers
- **PostgreSQL**: Database backend for both services
- **Ollama**: Local LLM server for running models on your own infrastructure

Perfect for creating automated AI agents that can process data, make decisions, and interact with various services and APIs.

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

Edit the `.env` file to set your database credentials, LiteLLM keys, and other configuration options.

For generating secure passwords and keys, you can use:
```bash
# For database passwords
openssl rand -base64 32

# For LiteLLM API keys (more appropriate for API key format)
openssl rand -hex 32
```

3. Create an external network for Caddy:

```bash
docker network create caddy-network
```

4. Start the containers:

```bash
docker compose up -d
```

5. Access services through your browser:
   - n8n: `http://localhost:5678`
   - LiteLLM API: `http://localhost:4000`
   - Ollama API: `http://localhost:11434`

## Using Ollama

### Installing Models

Once the Ollama service is running, you can install and run models using the Ollama API. To install a model, run:

```bash
# Install a model (e.g., llama3)
curl -X POST http://localhost:11434/api/pull -d '{"name": "llama3"}'
```

Or using docker exec:

```bash
docker exec -it ollama ollama pull llama3
```

### Running Models

To run a model in interactive mode:

```bash
docker exec -it ollama ollama run llama3
```

### Connecting Ollama to LiteLLM

You can connect Ollama to LiteLLM through the LiteLLM UI:

1. Access the LiteLLM UI at `http://localhost:4000/ui`
2. Log in with your credentials
3. Navigate to Models/Providers section
4. Add Ollama as a provider using the internal URL: `http://ollama:11434`
5. Set up model routing configurations as needed

This allows you to access Ollama models through the standardized LiteLLM API interface.

## Stopping the Service

To stop the containers:

```bash
docker compose down
```

## Upgrading Services

To upgrade to the latest versions:

```bash
# Pull latest versions
docker compose pull

# Stop and remove older versions
docker compose down

# Start the containers
docker compose up -d
```

## Environment Variables

The following important environment variables can be configured in your `.env` file:

### PostgreSQL Configuration
- `POSTGRES_USER`: PostgreSQL root username
- `POSTGRES_PASSWORD`: PostgreSQL root password

### n8n Configuration
- `N8N_POSTGRES_DB`: Database name for n8n
- `N8N_POSTGRES_USER`: Database user for n8n
- `N8N_POSTGRES_PASSWORD`: Database password for n8n
- `N8N_PROTOCOL`: Protocol to use (http or https)
- `N8N_HOST`: Hostname for n8n
- `WEBHOOK_URL`: URL for webhooks
- `GENERIC_TIMEZONE`: Timezone for n8n to use (UTC, Europe/Berlin, etc.)

### LiteLLM Configuration
- `LITELLM_POSTGRES_DB`: Database name for LiteLLM
- `LITELLM_POSTGRES_USER`: Database user for LiteLLM
- `LITELLM_POSTGRES_PASSWORD`: Database password for LiteLLM
- `LITELLM_MASTER_KEY`: Master key for LiteLLM admin access
- `LITELLM_SALT_KEY`: Salt key for credential encryption
- `LITELLM_UI_USERNAME`: Username for LiteLLM admin UI access
- `LITELLM_UI_PASSWORD`: Password for LiteLLM admin UI access

## Important Notes

- The `init-db.sh` script automatically creates databases for n8n and LiteLLM based on the environment variables.
- The databases are populated using the values from `N8N_POSTGRES_DB` and `LITELLM_POSTGRES_DB` environment variables.
- All data is stored in Docker volumes for persistence.
- You can place files you want to access from n8n in the `./files` directory, which is mounted to `/files` in the n8n container.
- LiteLLM configuration is stored in `litellm-config.yaml`.
- LiteLLM admin UI is accessible at `http://localhost:4000/ui` using the credentials set in the environment variables.
- This setup uses an external `caddy-network` which should be created before running the containers.
- For security in production environments, be sure to set strong passwords and keys.
- Ollama models are stored in the `ollama-data` volume for persistence.
