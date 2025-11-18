all : build up 

start : up

stop : down

build :
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

re : destroy all

.PHONY: all build up down logs clean destroy re start stop
