#!/usr/bin/env bash
set -euo pipefail

PASSWORD_FILE="/mosquitto/config/passwordfile"

# Check if 
: "${GROWATT_SN:?Serial not set}"

rm -f "$PASSWORD_FILE"
touch "$PASSWORD_FILE"

# Reas Serials to users
IFS=',' read -ra SERIALS <<< "$GROWATT_SN"

for serial in "${SERIALS[@]}"; do
  username="${serial}"
  password="Growatt"

  mosquitto_passwd -b "$PASSWORD_FILE" "$username" "$password"
done

chown mosquitto:mosquitto "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"
