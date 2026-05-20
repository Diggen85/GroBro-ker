# GroBro-Ker

Secure Mosquitto MQTT broker with integrated Certbot auto-renewal and automatic user provisioning for GroBro / Growatt needs

---
# Features

- Automatic Let's Encrypt certificate creation
- Automatic certificate renewal
- Mosquitto TLS configuration on Port 7006
- Automatic MQTT password file generation for Growatt Serials
- Non-root service execution
- Supervisor + Cron based process handling

- Needs reachable Port 80 (Container 8080) for Certbot

---
# Example docker-compose.yaml

see docker-compose.yaml

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
| `/mosquitto/data` | mosquitto.db for persistence |

---
# Ports

| Port | Description |
|---|---|
| `8080` | Certbot HTTP challenge |
| `7006` | MQTT with TLS for Growatt Devices |

---
# License

MIT License
