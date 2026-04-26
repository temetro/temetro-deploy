# Temetro Deploy

Temetro Deploy contains the Docker Compose and NGINX configuration needed to run Temetro locally or on a self-hosted server.

## Requirements

- Docker installed
- Docker Compose v2 available through `docker compose`
- Git installed
- Minimum 2 GB RAM

## One-command installation

```bash
git clone https://github.com/temetro/temetro-deploy
cd temetro-deploy
cp .env.example .env
```

Edit `.env`, then start the stack:

```bash
docker compose up -d
```

Open:

- `http://localhost:3000` for the dashboard
- `http://localhost:3001/docs` for documentation

## Environment variables

| Variable | Required | Description | Example |
| --- | --- | --- | --- |
| `POSTGRES_PASSWORD` | Yes | Password used by the PostgreSQL `temetro` user | `change-me-now` |
| `APP_URL` | Yes | Public URL for the dashboard and Better Auth base URL | `http://localhost:3000` |
| `BETTER_AUTH_SECRET` | Yes | Secret used by Better Auth to sign and protect sessions | generated with `openssl rand -base64 32` |
| `SMTP_HOST` | No | SMTP hostname for outbound email | `smtp.example.org` |
| `SMTP_PORT` | No | SMTP port for outbound email | `587` |
| `SMTP_USER` | No | SMTP username | `temetro@example.org` |
| `SMTP_PASS` | No | SMTP password | `super-secret-mail-password` |

## First admin user

After the services start:

1. Open `http://localhost:3000`
2. Click **Create an account**
3. Register the first administrator with a secure password
4. Store that credential in the hospital password manager

If you want demo records after first run:

```bash
docker compose exec web npm run seed
```

## Upgrading Temetro

When a new version is available:

1. Back up the PostgreSQL database
2. Pull the latest repository changes
3. Rebuild and restart the services

```bash
git pull
docker compose up -d --build
```

Then verify:

- The sign-in page loads
- The dashboard opens after sign-in
- `/docs` routes to the documentation site

## Troubleshooting

### Port conflicts

If Docker reports that a port is already in use:

- Check whether another web server is using port `3000`, `3001`, `80`, `443`, or `5432`
- Stop the conflicting service or remap the ports in the Compose file

### Database connection errors

If the web container cannot connect to PostgreSQL:

- Confirm `postgres` is healthy with `docker compose ps`
- Check the value of `POSTGRES_PASSWORD` in `.env`
- Restart the stack after updating credentials
- Review logs with `docker compose logs -f postgres web`

### Permission issues

If Docker cannot read files or write volumes:

- Confirm the current user has permission to the deployment folder
- Avoid placing the project in a restricted system directory
- On Linux, confirm the Docker service account can access mounted paths

## Production startup

To include NGINX and production overrides:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Before production use, place SSL certificate files in `./ssl` and review `nginx.conf`.
