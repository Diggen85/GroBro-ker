#!/usr/bin/env bash
set -e

: "${CERTBOT_DOMAIN:?Domainname not set}"
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
    -d "${DOMAIN}" \
    --deploy-hook /usr/local/bin/copy-mosquitto-cert.sh
fi

# Renewal
certbot renew \
  --quiet \
  --http-01-port 8080 \
  --deploy-hook /usr/local/bin/copy-mosquitto-cert.sh

# Display Cert
certbot certificates --cert-name "${DOMAIN}"
