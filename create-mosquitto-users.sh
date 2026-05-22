#!/usr/bin/env bash
set -euo pipefail

PASSWORD_FILE="/etc/mosquitto/passwordfile"

# Check if 
: "${GROWATT_SN:?Serial not set}"
: "${GROBRO_USER:?GroBro User not set}"
: "${GROBRO_PASS:?GroBro Pass not set}"

# Clear Password File
rm -f "$PASSWORD_FILE"
touch "$PASSWORD_FILE"

# Create Gobro User
mosquitto_passwd -b "$PASSWORD_FILE" "$GROBRO_USER" "$GROBRO_PASS"
# Read Serials to and Create Users
IFS=',' read -ra SERIALS <<< "$GROWATT_SN"

for serial in "${SERIALS[@]}"; do
  username="${serial}"
  password="Growatt"

  mosquitto_passwd -b "$PASSWORD_FILE" "$username" "$password"
done

chown mosquitto:mosquitto "$PASSWORD_FILE"
chmod 0700 "$PASSWORD_FILE"

# Moquitto reload config
pkill -HUP mosquitto
