#!/usr/bin/env bash
set -e

: "${CERTBOT_DOMAIN:?Domainname not set}"
: "${CERTBOT_EMAIL:?Email not set}"

CERT_DIR="/etc/letsencrypt/live/${CERTBOT_DOMAIN}"
MOSQUITTO_CERT_DIR="/mosquitto/certs"

# create initial Certificate if missing
if [ ! -f "${CERT_DIR}/fullchain.pem" ]; then
  certbot certonly \
    --standalone \
    --http-01-port 8080 \
    --non-interactive \
    --agree-tos \
    --email "${CERTBOT_EMAIL}" \
    -d "${CERTBOT_DOMAIN}"
else 
  # Renewal
  certbot renew \
    --quiet \
    --http-01-port 8080
fi

/usr/local/bin/copy-mosquitto-cert.sh

# Display Cert
certbot certificates --cert-name "${CERTBOT_DOMAIN}"
