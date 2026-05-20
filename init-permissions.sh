#!/usr/bin/env bash
set -euo pipefail

fix_owner() {
  local expected="$1"
  local path="$2"

  current="$(stat -c '%U:%G' "$path" 2>/dev/null || true)"

  if [ "$current" != "$expected" ]; then
    echo "Fix owner $path -> $expected"
    chown -R "$expected" "$path"
  fi
}

fix_mode() {
  local expected="$1"
  local path="$2"

  current="$(stat -c '%a' "$path" 2>/dev/null || true)"

  if [ "$current" != "$expected" ]; then
    echo "Fix permissions $path -> $expected"
    chmod "$expected" "$path"
  fi
}

mkdir -p \
  /etc/letsencrypt \
  /var/lib/letsencrypt \
  /var/log/letsencrypt \
  /mosquitto/data \
  /mosquitto/log \
  /mosquitto/certs \
  /mosquitto/config

fix_owner certbot:certbot /etc/letsencrypt
fix_owner certbot:certbot /var/lib/letsencrypt
fix_owner certbot:certbot /var/log/letsencrypt

fix_owner mosquitto:mosquitto /mosquitto/data
fix_owner mosquitto:mosquitto /mosquitto/log
fix_owner mosquitto:mosquitto /mosquitto/config

fix_owner certbot:mosquitto /mosquitto/certs

fix_mode 750 /mosquitto/certs
fix_mode 700 /etc/letsencrypt

echo "Permissions set"
