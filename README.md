# GroBro-Ker

Secure Mosquitto MQTT broker with integrated Certbot auto-renewal and automatic user provisioning for [GroBro](https://github.com/robertzaage/GroBro/) to use your Growatt NEO/SPF/TL-XH2 inverters, NOAH/NEXA batteries and ShineWeLink-X2 dataloggers localy.

---
# Features

- Automatic Let's Encrypt certificate creation
- Automatic certificate renewal, check every 12 hours
- Mosquitto TLS configuration on Port 7006
- Automatic MQTT password file generation for Growatt Serials
- Non-root service execution
- Supervisor + Cron based process handling

---
# Notes

- GroBro-ker needs a reachable Port 80 (Container 8080) for Certbot
- If you run GroBro-ker behind NPM (NginX Proxy Manager), use the following workaround config under "Adavanced" to passthrough the acme-challange
   ```
   rewrite ^(/.well-known/acme-challenge/.*)$ /internal$1 last;
   location ~ ^/internal(/.well-known/acme-challenge/.*)$ {
     proxy_pass http://grobro-ker:8080$1;
   }
   ```
- Config for GroBro
   | Variable | Description |
   |---|---|
   | `SOURCE_MQTT_HOST:` | `grobro-ker` if they are in the same docker network / docker host IP  / `CERTBOT_DOMAIN`  |
   | `SOURCE_MQTT_PORT` | `7006` |
   | `SOURCE_MQTT_TLS` | `true` |
   | `SOURCE_MQTT_USER` | same as `GROBRO_USER` |
   | `SOURCE_MQTT_PASS` | same as `GROBRO_PASS` | 
  

---
# Example docker-compose.yaml

see [docker-compose.yaml](https://github.com/Diggen85/GroBro-ker/blob/main/docker-compose.yaml)

---
# Container

The container images are published to:

```text
ghcr.io/diggen85/grobro-ker
```

## Available Tags

| Tag | Description |
|---|---|
| `dev` | Development builds |
| `latest` | Latest stable release build |
| `vX.Y.Z` | Specific release version |
| `weekly` | Automatically rebuilt weekly image with updated Alpine packages |

---

# Environment Variables

| Variable | Description |
|---|---|
| `CERTBOT_DOMAIN` | Domain name used for the Let's Encrypt certificate. |
| `CERTBOT_EMAIL` | Email address used for Let's Encrypt registration and renewal notifications. |
| `GROWAT_SN` | Comma separated list of Growatt serial numbers. |
| `GROBRO_USER` | mMQTT username used for broker authentication. |
| `GROBRO_PASS` | MQTT password used for broker authentication. |

---
# Volumes

| Volume | Description |
|---|---|
| `/etc/letsencrypt` | Cerbot Certificates |
| `/var/lib/mosquitto` | Path of mosquitto.db for persistence |

---
# Ports

| Port | Description |
|---|---|
| `8080` | Certbot HTTP challenge |
| `7006` | MQTT with TLS for Growatt Devices |

---
# License

MIT License
