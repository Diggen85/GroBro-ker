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
  /var/lib/mosquitto \
  /etc/mosquitto/certs \

fix_owner certbot:certbot /etc/letsencrypt
fix_owner certbot:certbot /var/lib/letsencrypt
fix_owner certbot:certbot /var/log/letsencrypt

fix_owner mosquitto:mosquitto /var/lib/mosquitto
fix_owner certbot:mosquitto /etc/mosquitto/certs

fix_mode 750 /etc/mosquitto/certs
fix_mode 700 /etc/letsencrypt
fix_mode 700 /var/lib/mosquitto

echo "Permissions set"
