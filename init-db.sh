#!/bin/bash

set -e

# Function to create databases from a comma-separated list
create_dbs() {
  local dbs="$1"
  echo "Creating databases: $dbs"

  IFS=',' read -ra DB_NAMES <<< "$dbs"
  for db in "${DB_NAMES[@]}"; do
    db=$(echo "$db" | xargs)

    if [ -z "$db" ]; then
      continue
    fi

    local CREATE_DB_SQL="
      CREATE DATABASE \"$db\";
    "

    echo "$CREATE_DB_SQL" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"
    echo "Database $db created successfully"
  done
}

# Function to create a database user and grant privileges
create_user_and_grant_privileges() {
  local username="$1"
  local password="$2"
  local db="$3"
  echo "Creating user: $username and granting privileges to database: $db"

  # SQL command to create user and grant privileges
  local USER_CREATION_SQL="
    CREATE USER \"$username\" WITH PASSWORD '$password';
    GRANT ALL PRIVILEGES ON DATABASE \"$db\" TO \"$username\";
  "

  # SQL commands to set schema privileges (needs to connect to the specific database)
  local SCHEMA_PRIVILEGES_SQL="
    GRANT ALL PRIVILEGES ON SCHEMA public TO \"$username\";
    ALTER ROLE \"$username\" SET search_path TO public;
  "

  echo "$USER_CREATION_SQL" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"
  echo "$SCHEMA_PRIVILEGES_SQL" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db"

  echo "User $username created successfully"
}

# Create databases
if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
  create_dbs "$POSTGRES_MULTIPLE_DATABASES"
else
  echo "WARNING: POSTGRES_MULTIPLE_DATABASES not set. No databases created."
fi

# Set up n8n user and permissions
if [ -n "${N8N_POSTGRES_USER:-}" ] && [ -n "${N8N_POSTGRES_PASSWORD:-}" ] && [ -n "${N8N_POSTGRES_DB:-}" ]; then
  create_user_and_grant_privileges "$N8N_POSTGRES_USER" "$N8N_POSTGRES_PASSWORD" "$N8N_POSTGRES_DB"
else
  echo "WARNING: n8n database user environment variables not set. Skipping n8n user creation."
fi

# Set up LiteLLM user and permissions
if [ -n "${LITELLM_POSTGRES_USER:-}" ] && [ -n "${LITELLM_POSTGRES_PASSWORD:-}" ] && [ -n "${LITELLM_POSTGRES_DB:-}" ]; then
  create_user_and_grant_privileges "$LITELLM_POSTGRES_USER" "$LITELLM_POSTGRES_PASSWORD" "$LITELLM_POSTGRES_DB"
else
  echo "WARNING: LiteLLM database user environment variables not set. Skipping LiteLLM user creation."
fi
