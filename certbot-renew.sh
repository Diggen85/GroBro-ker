#!/usr/bin/env bash
set -e

: "${DOMAIN:?Domainname not set}"
: "${EMAIL:?Email not set}"

CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"
MOSQUITTO_CERT_DIR="/mosquitto/certs"

copy_certs() {
  cp "${CERT_DIR}/fullchain.pem" "${MOSQUITTO_CERT_DIR}/fullchain.pem"
  cp "${CERT_DIR}/privkey.pem" "${MOSQUITTO_CERT_DIR}/privkey.pem"

  chmod 640 "${MOSQUITTO_CERT_DIR}"/*.pem

  pkill -HUP mosquitto || true
}

# create initial Certificate if missing
if [ ! -f "${CERT_DIR}/fullchain.pem" ]; then
  certbot certonly \
    --standalone \
    --http-01-port 8080 \
    --non-interactive \
    --agree-tos \
    --email "${EMAIL}" \
    -d "${DOMAIN}"
fi

# Renewal
certbot renew \
  --quiet \
  --http-01-port 8080

# Display Cert
certbot certonly --cert-name "${DOMAIN}"

# Copy Certs to Mosquitto
copy_certs
