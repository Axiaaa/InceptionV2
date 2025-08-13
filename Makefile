all : build up 

start : up

stop : down

build :
	mkdir -p /home/lcamerly/data/mariadb
	mkdir -p /home/lcamerly/data/nginx
	docker compose build 

up :
	docker compose up -d

down :
	docker compose down

logs :
	docker compose logs -f

destroy:
	docker compose down --rmi all -v

clean : destroy
	docker system prune -af

re : destroy all

.PHONY: all build up down logs clean destroy re start stop
