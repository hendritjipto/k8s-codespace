#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$ROOT_DIR/.env"
TEMPLATE_FILE="$ROOT_DIR/definition.yaml.template"
VALUES_FILE="$ROOT_DIR/definition.yaml"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found."
  echo "Copy .env.example to .env and fill in all values first."
  exit 1
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "Error: $TEMPLATE_FILE not found."
  exit 1
fi

if ! command -v envsubst >/dev/null 2>&1; then
  echo "Error: envsubst is not installed. Install it with: sudo apt-get update && sudo apt-get install -y gettext-base"
  exit 1
fi

# Export all variables from .env into this shell.
set -a
source "$ENV_FILE"
set +a

required_vars=(
  GRAFANA_CLOUD_METRICS_USERNAME
  GRAFANA_CLOUD_METRICS_PASSWORD
  GRAFANA_CLOUD_LOGS_USERNAME
  GRAFANA_CLOUD_LOGS_PASSWORD
  GC_OTLP_ENDPOINT_USERNAME
  GC_OTLP_ENDPOINT_PASSWORD
  GRAFANA_CLOUD_PROFILES_USERNAME
  GRAFANA_CLOUD_PROFILES_PASSWORD
  COLLECTOR_REMOTE_CONFIG_USERNAME
  COLLECTOR_REMOTE_CONFIG_PASSWORD
)

for var_name in "${required_vars[@]}"; do
  if [[ -z "${!var_name:-}" ]]; then
    echo "Error: required env var '$var_name' is empty or undefined in .env"
    exit 1
  fi
done

# Rebuild definition.yaml from template with current .env values before Helm runs.
envsubst < "$TEMPLATE_FILE" > "$VALUES_FILE"

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install --rollback-on-failure --timeout 300s grafana-k8s-monitoring grafana/k8s-monitoring \
  --version "^4" --namespace "grafana" --create-namespace --values "$VALUES_FILE"

echo "Deployment completed successfully."
