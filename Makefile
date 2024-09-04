.PHONY: all build

all: help

prod:  ## Start the project in production mode
	@docker compose -f docker/compose.yml up -d
dev: ## Start the project in development mode (in dev machine and with hot reload)
	@docker compose -f docker/compose.yml up -d postgres
	@pnpm migration:run
	@pnpm dev
stop: ## Stop the project
	@docker compose -f docker/compose.yml down
clean: ## Remove all stuff
	@docker compose -f docker/compose.yml down --rmi all --volumes

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
