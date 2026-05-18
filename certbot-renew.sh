#!/usr/bin/env bash
set -e

: "${CERBOT_DOMAIN:?Domainname not set}"
: "${CERTBOT_EMAIL:?Email not set}"

CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"
MOSQUITTO_CERT_DIR="/mosquitto/certs"

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
