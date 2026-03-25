DOC.md — Inception Stack

## Overview

This stack deploys a self-hosted web infrastructure composed of the following services:

| Service          | Role                                                                        |
| ---------------- | --------------------------------------------------------------------------- |
| **WordPress**    | Wordpress template                                                          |
| **Nginx**        | HTTPS reverse proxy, serves WordPress and routes to sub-services            |
| **MariaDB**      | Wordpress database                                                          |
| **Redis**        | In-memory cache for WordPress                                               |
| **Adminer**      | Web-based database manage                                                   |
| **Beszel**       | System & container monitoring dashboard                                     |
| **Beszel Agent** | Collects metrics from the Docker host and reports to Beszel                 |

All services use internal Docker bridge network called `inception`. Only port **443** and **FTP Ports** are exposed.

---

## Starting and Stopping the Project


```bash
# Build images and start all services (detached)
make

# Start without rebuilding
make start

# Stop all services (containers are kept)
make stop

# Destroy containers, images, volumes and data
make destroy

# View live logs
make logs
```

> **Note:** The makefile takes care of directory creation and cleanup.

---

## Accessing the Services

All services are accessed through the Nginx reverse proxy over HTTPS.

|Service|URL|
|---|---|
|**WordPress site**|`https://lcamerly.42.fr/`|
|**WordPress admin**|`https://lcamerly.42.fr/wp-admin`|
|**Adminer**|`https://lcamerly.42.fr/adminer`|
|**Beszel**|`https://lcamerly.42.fr/beszel`|


---

## Credentials

All sensitive credentials are stored in a `.env` file at the root of the repository. **This file is not committed to version control** (it is listed in `.gitignore`).

There's a .env_example at the root of this repository that serves as template.
---

## Checking That Services Are Running

**Quick status check:**

```bash
docker compose ps
```

All containers should show status `running (healthy)` once fully started.

**View logs for a specific service:**

```bash
docker compose logs -f wordpress
docker compose logs -f mariadb
docker compose logs -f nginx
```

**Check Nginx is responding:**

```bash
curl -sk https://localhost/status
```

A response containing Nginx stub status metrics confirms the proxy is up.

**Check Redis:**

```bash
docker exec redis redis-cli ping
# Expected output: PONG
```

**Check MariaDB:**

```bash
docker exec mariadb mariadb -u root -p<MYSQL_ROOT_PASSWORD> -e "SHOW DATABASES;"
```
Or you can also use `https://lcamerly.42.fr/adminer` to check if the database works.

**Monitor all services visually:** open `https://lcamerly.42.fr/beszel` in your browser to see real-time CPU, memory, and container health metrics.

