#!/bin/sh
#
# redis-cli.sh - Redis connection script for FUB development environment
#
# Usage:
#   ./redis-cli.sh <redis-cli-args>
#
# Examples:
#   ./redis-cli.sh ping
#   ./redis-cli.sh keys "fubapp:mutex:*"
#   ./redis-cli.sh get "fubapp:mutex:migrations-script"
#   ./redis-cli.sh del "fubapp:mutex:migrations-script"
#
# This script encapsulates the FUB Redis connection details so other scripts
# can reuse it without duplicating connection configuration.
#

set -eu

# FUB Redis Configuration (Development Environment)
REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
REDIS_PORT="${REDIS_PORT:-22125}"
REDIS_PASS="${REDIS_PASS:-Engineering1!}"

# Execute redis-cli with FUB connection parameters
redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -a "$REDIS_PASS" "$@"