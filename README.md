# AgentForge

🤖 **A comprehensive framework for building and deploying AI agents**

AgentForge combines powerful workflow automation with standardized LLM access to create a complete environment for developing intelligent agents that can process data, make decisions, and interact with various services and APIs.

## 🚀 What is AgentForge?

AgentForge is an all-in-one platform that brings together the best tools for AI agent development:

## 🏗️ Architecture Overview

This platform integrates five powerful components:

- **🔄 n8n**: Powerful workflow automation platform for building complex agent logic and decision trees
- **🌐 LiteLLM**: Proxy server providing standardized access to 100+ LLM providers (OpenAI, Anthropic, Cohere, etc.)
- **🗄️ PostgreSQL**: Robust database backend for persistent data storage across all services
- **🧠 Ollama**: Local LLM server for running open-source models on your own infrastructure
- **💬 Open WebUI**: Modern, intuitive web interface for interacting with your AI models

**Perfect for:** Creating sophisticated AI agents that can automate workflows, process complex data, integrate with APIs, and provide intelligent responses through multiple interfaces.

## 📋 Prerequisites

- Docker
- Docker Compose

## 🚀 Quick Start

### 1. 📁 Prepare Your Environment

Create a directory for files that will be accessible by n8n:

```bash
mkdir -p files
```

### 2. ⚙️ Configure Environment Variables

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit the `.env` file to set your database credentials, LiteLLM keys, and other configuration options.

💡 **Pro Tip:** Generate secure passwords and keys:
```bash
# For database passwords
openssl rand -base64 32

# For LiteLLM API keys (more appropriate for API key format)
openssl rand -hex 32
```

### 3. 🌐 Setup Network

Create an external network for Caddy (if you plan to use reverse proxy):

```bash
docker network create caddy-network
```

### 4. 🚀 Launch AgentForge

Start all services:

```bash
docker compose up -d
```

### 5. 🎯 Access Your Services

Once everything is running, access your AgentForge platform:

- **🔄 n8n Workflow Builder**: `http://localhost:5678`
- **🌐 LiteLLM API Dashboard**: `http://localhost:4000`
- **🧠 Ollama API**: `http://localhost:11434`
- **💬 Open WebUI Chat Interface**: `http://localhost:8080`

## 🧠 Using Ollama

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

## 💬 Using Open WebUI

Open WebUI provides a user-friendly interface for interacting with your Ollama models through a modern chat interface.

### Getting Started with Open WebUI

1. Make sure Ollama is running and has at least one model installed
2. Access Open WebUI at `http://localhost:8080`
3. Create an account or log in
4. Start chatting with your local Ollama models

### Key Features

- **Chat Interface**: Intuitive chat interface similar to popular AI assistants
- **Model Selection**: Switch between different Ollama models
- **Secure Authentication**: User accounts with authentication
- **Chat History**: Persistent chat history stored in the open-webui-data volume
- **File Uploads**: Upload files for the AI to analyze (depending on model capabilities)
- **Customization**: Adjust various settings to tailor your experience

### Authentication

- The first user to register will automatically become an admin
- Admin users can manage user accounts and system settings
- The `WEBUI_SECRET_KEY` environment variable is used for securing authentication
- For production use, ensure you set a strong random key for `WEBUI_SECRET_KEY`

### API Access

Open WebUI provides API access for integration with other applications:

1. Navigate to your account settings in the Open WebUI interface
2. Generate an API key and/or JWT token
3. Use these credentials to authenticate with the Open WebUI API

### Security Considerations

When deploying Open WebUI in a production environment, consider these security practices:

- **Generate a Strong Secret Key**: Use a cryptographically secure random generator to create a `WEBUI_SECRET_KEY` with at least 64 characters
- **Enable HTTPS**: For production deployments, configure your reverse proxy (e.g., Caddy) to use HTTPS
- **Cookie Security**: When using HTTPS, make sure `WEBUI_SESSION_COOKIE_SECURE` and `WEBUI_AUTH_COOKIE_SECURE` are set to `True`
- **User Management**: Review and approve new user registrations, especially when setting `DEFAULT_USER_ROLE=pending`
- **API Access Control**: Be cautious when sharing API keys and always use the shortest viable token expiration time
- **Regular Updates**: Keep your Open WebUI instance updated to the latest version to benefit from security patches

## 🛠️ Management Commands

### Stopping the Service

To stop the containers:

```bash
docker compose down
```

### Upgrading Services

To upgrade to the latest versions:

```bash
# Pull latest versions
docker compose pull

# Stop and remove older versions
docker compose down

# Start the containers
docker compose up -d
```

## ⚙️ Environment Variables

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

### Open WebUI Configuration
- `WEBUI_SECRET_KEY`: Secret key for JWT token generation and authentication (at least 64 characters recommended for security)

## 📝 Important Notes

- The `init-db.sh` script automatically creates databases for n8n and LiteLLM based on the environment variables
- The databases are populated using the values from `N8N_POSTGRES_DB` and `LITELLM_POSTGRES_DB` environment variables
- All data is stored in Docker volumes for persistence
- You can place files you want to access from n8n in the `./files` directory, which is mounted to `/files` in the n8n container
- LiteLLM configuration is stored in `litellm-config.yaml`
- LiteLLM admin UI is accessible at `http://localhost:4000/ui` using the credentials set in the environment variables
- Open WebUI provides a user-friendly interface for interacting with your Ollama models through a modern chat interface
- This setup uses an external `caddy-network` which should be created before running the containers
- For security in production environments, be sure to set strong passwords and keys
- Ollama models are stored in the `ollama-data` volume for persistence
- Open WebUI data (chats, settings) is stored in the `open-webui-data` volume for persistence

## 🔗 Resources

- **GitHub Repository**: [https://github.com/nbsp1221/agentforge](https://github.com/nbsp1221/agentforge)
- **n8n Documentation**: [https://docs.n8n.io/](https://docs.n8n.io/)
- **LiteLLM Documentation**: [https://docs.litellm.ai/](https://docs.litellm.ai/)
- **Ollama Documentation**: [https://ollama.ai/](https://ollama.ai/)
- **Open WebUI Documentation**: [https://docs.openwebui.com/](https://docs.openwebui.com/)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**AgentForge** - 🤖 *Forge your AI agents with confidence*