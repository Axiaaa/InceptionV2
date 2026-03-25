all : build up

start : up

stop : down

build :
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/wordpress-files
	docker compose --file srcs/docker-compose.yml build

up :
	docker compose --file srcs/docker-compose.yml up -d

down :
	docker compose --file srcs/docker-compose.yml down

logs :
	docker compose --file srcs/docker-compose.yml logs -f

destroy:
	docker compose --file srcs/docker-compose.yml down --rmi all -v
	sudo rm -rf /home/${USER}/data/*


clean : destroy
	docker system prune -af

re : destroy all

.PHONY: all build up down logs clean destroy re start stop
