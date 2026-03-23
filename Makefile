all : build up 

start : up

stop : down

build :
	sudo mkdir -p /home/lcamerly/data/mariadb
	sudo mkdir -p /home/lcamerly/data/wordpress-files
	docker compose build

up :
	docker compose up -d

down :
	docker compose down

logs :
	docker compose logs -f

destroy:
	docker compose down --rmi all -v
	sudo rm -rf /home/lcamerly/data/*


clean : destroy
	docker system prune -af

re : destroy all

.PHONY: all build up down logs clean destroy re start stop
