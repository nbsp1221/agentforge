#!/bin/bash

set -e

# SQL commands to create a non-root user and grant necessary permissions
SQL_COMMANDS="
  CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
  GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
  GRANT ALL PRIVILEGES ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
"

# Check if required environment variables are set
if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
  echo "$SQL_COMMANDS" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
else
  echo "Error: Required environment variables POSTGRES_NON_ROOT_USER or POSTGRES_NON_ROOT_PASSWORD are not set!"
  exit 1
fi
