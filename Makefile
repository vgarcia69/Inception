NAME=inception
DBPATH=/home/vince/data/mariadb

all: build up

down:
	@echo "Shutting down $(NAME)"
	docker compose -p $(NAME) down

build:
	@echo "Building $(NAME)"
	@mkdir -p $(DBPATH)
	docker compose --project-directory ./srcs/ -p $(NAME) build


up: 
	@echo "Starting $(NAME)"
	docker compose --project-directory ./srcs/ -p $(NAME) up -d

clean: down
	@echo "Cleaning $(NAME)"
	@rm -rf $(DBPATH)
	docker system prune -af --volumes

.PHONY: clean up build down