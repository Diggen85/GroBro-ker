FROM alpine:latest

LABEL org.opencontainers.image.title="GroBro-Ker"
LABEL org.opencontainers.image.description="Secure Mosquitto MQTT broker with integrated Certbot auto-renewal and automatic user provisioning."
LABEL org.opencontainers.image.authors="Diggen85 (B. Stark)"
LABEL org.opencontainers.image.licenses="MIT"

RUN apk add --no-cache \
    bash \
    certbot \
    mosquitto \
    mosquitto-clients \
    supervisor \
    tini \
    dcron \
    ca-certificates \
    openssl

# Create directorys and volumes
RUN mkdir -p \
    /etc/letsencrypt \
    /etc/letsencrypt/renewal-hooks/deploy \
    /var/lib/letsencrypt \
    /var/log/letsencrypt \
    /mosquitto \
    /mosquitto/data \
    /mosquitto/log \
    /mosquitto/certs \
    /mosquitto/config \
    /var/spool/cron/crontabs


# Add User
RUN (getent group mosquitto || addgroup -S mosquitto) \
    && (id mosquitto || adduser -S -D -H -h /mosquitto -s /sbin/nologin -G mosquitto mosquitto) \
    && (getent group certbot || addgroup -S certbot) \
    && (id certbot || adduser -S -D -H -h /var/lib/letsencrypt -s /sbin/nologin -G certbot certbot) \
    && addgroup certbot mosquitto 2>/dev/null || true

# Set rights
RUN chown -R certbot:certbot \
    /etc/letsencrypt \
    /var/lib/letsencrypt \
    /var/log/letsencrypt
RUN chown -R mosquitto:mosquitto /mosquitto
RUN chown certbot:mosquitto /mosquitto/certs
RUN chmod 750 /mosquitto/certs

VOLUME /etc/letsencrypt /mosquitto/data

COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY supervisord.conf /etc/supervisord.conf
COPY crontab /var/spool/cron/crontabs/certbot
COPY certbot-renew.sh /usr/local/bin/certbot-renew.sh
COPY create-mosquitto-users.sh /usr/local/bin/create-mosquitto-users.sh
COPY copy-mosquitto-cert.sh /usr/local/bin/copy-mosquitto-cert.sh
COPY start-mosquitto.sh /usr/local/bin/start-mosquitto.sh
COPY init-permissions.sh /usr/local/bin/init-permissions.sh

RUN chmod +x /usr/local/bin/certbot-renew.sh \
    /usr/local/bin/create-mosquitto-users.sh \
    /usr/local/bin/copy-mosquitto-cert.sh \
    /usr/local/bin/start-mosquitto.sh \
    /usr/local/bin/init-permissions.sh
RUN chmod 600 /var/spool/cron/crontabs/certbot
RUN chown certbot:certbot /var/spool/cron/crontabs/certbot

EXPOSE 8080 7006

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
