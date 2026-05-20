#!/usr/bin/env bash
set -euo pipefail

while [ ! -f /etc/mosquitto/passwordfile ]; do
  echo "Waiting for passwordfile..."
  sleep 2
done

while [ ! -f /etc/mosquitto/certs/server.pem ]; do
  echo "Waiting for certificates..."
  sleep 2
done

while [ ! -f/etc/mosquitto/certs/server.key ]; do
  echo "Waiting for certificate keys..."
  sleep 2
done


exec mosquitto -c /etc/mosquitto/mosquitto.conf
