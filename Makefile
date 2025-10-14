NAME=inception
DBPATH=/home/vgarcia/data/
SRCDIR=srcs/

all: build up

re: clean build up

down:
	@echo "Shutting down $(NAME)"
	docker compose -p $(NAME) down

build:
	@echo "Building $(NAME)"
	@mkdir -p $(DBPATH)
	docker compose --project-directory $(SRCDIR) -p $(NAME) build

up: 
	@echo "Starting $(NAME)"
	docker compose --project-directory $(SRCDIR) -p $(NAME) up 

clean:
	@echo "Cleaning $(NAME)"
	@rm -rf $(DBPATH)
	docker compose -p $(NAME) --project-directory $(SRCDIR) down -v --remove-orphans
	docker system prune -af --volumes

.PHONY: clean up build down all re