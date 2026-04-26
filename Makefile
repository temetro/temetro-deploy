.PHONY: up down logs migrate seed reset prod-up

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

migrate:
	docker compose exec web npm run migrate

seed:
	docker compose exec web npm run seed

reset:
	docker compose down -v && docker compose up -d

prod-up:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
