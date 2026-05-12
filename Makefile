
COMPOSE_FILE	= srcs/docker-compose.yml
DATA_DIR		= /home/$(USER)/data

all: setup
	docker compose -f $(COMPOSE_FILE) up --build -d

setup:
	@mkdir -p $(DATA_DIR)/db
	@mkdir -p $(DATA_DIR)/wordpress

down:
	docker compose -f $(COMPOSE_FILE) down

stop:
	docker compose -f $(COMPOSE_FILE) stop

start:
	docker compose -f $(COMPOSE_FILE) start

status:
	docker compose -f $(COMPOSE_FILE) ps

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

clean: down
	docker system prune -af

fclean: clean
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all setup down stop start status logs clean fclean re
