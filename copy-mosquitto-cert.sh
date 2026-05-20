#!/bin/sh
set -e 

: ${CERTBOT_DOMAIN:?Domain not set}

CERTIFICATE_DIR=/etc/mosquitto/certs

cp /etc/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem ${CERTIFICATE_DIR}/server.pem
cp /etc/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem ${CERTIFICATE_DIR}/server.key

# Set ownership to Mosquitto
chown certbot:mosquitto ${CERTIFICATE_DIR}/server.pem ${CERTIFICATE_DIR}/server.key

# Ensure permissions are restrictive
chmod 0640 ${CERTIFICATE_DIR}/server.pem ${CERTIFICATE_DIR}/server.key

# Tell Mosquitto to reload certificates and configuration
pkill -HUP -x mosquitto
