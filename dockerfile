FROM alpine:latest

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
VOLUME /etc/letsencrypt /mosquitto/data

# Add User
RUN (getent group mosquitto || addgroup -S mosquitto) \
    && (id mosquitto || adduser -S -D -H -d /mosquitto -s /sbin/nologin -G mosquitto mosquitto) \
    && (getent group certbot || addgroup -S certbot) \
    && (id certbot || adduser -S -D -H -d /var/lib/letsencrypt -s /sbin/nologin -G certbot certbot) \
    && addgroup certbot mosquitto 2>/dev/null || true

# Set rights
RUN chown -R certbot:certbot \
    /etc/letsencrypt \
    /var/lib/letsencrypt \
    /var/log/letsencrypt \
    && chown -R mosquitto:mosquitto /mosquitto \
    && chown certbot:mosquitto /mosquitto/certs \
    && chmod 750 /mosquitto/certs

COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY supervisord.conf /etc/supervisord.conf
COPY certbot-renew.sh /usr/local/bin/certbot-renew.sh
COPY create-mosquitto-users.sh /usr/local/bin/create-mosquitto-users.sh
COPY crontab /var/spool/cron/crontabs/certbot
COPY mosquitto-copy.sh /etc/letsencrypt/renewal-hooks/deploy/

RUN chmod +x /usr/local/bin/certbot-renew.sh /usr/local/bin/create-mosquitto-users.sh \
    && chmod 600 /var/spool/cron/crontabs/certbot \
    && chown certbot:certbot /var/spool/cron/crontabs/certbot

EXPOSE 8080 7006

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
