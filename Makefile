cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build:## Build the image
	docker build -t $(APP_NAME):$(VERSION) .
build-prod: ## Build prod image
	docker build -t ghcr.io/wignesh/bd-env/$(APP_NAME):$(VERSION) .
push: ## Push image to ghcr
	docker push ghcr.io/wignesh/bd-env/$(APP_NAME):$(VERSION) .
force-build:## Force Build the image
	docker build --no-cache -t $(APP_NAME):$(VERSION) .
run: ## Run container with `config.env`
	docker start $(APP_NAME) || docker run -d -v ${PWD}:/usr/bin/bd/fs --network ${NETWORK} -p 8080:8080 -p 8081:8081 -p 9870:9870 -p 9864:9864 -p 9866:9866 -p 9867:9867 -p 9868:9868 -p 9000:9000 --hostname $(HOSTNAME) --restart=always --name $(APP_NAME) $(APP_NAME):$(VERSION)
stop: ## Stop the hadoop container
	docker stop $(APP_NAME)
rm: ## Remove the hadoop container
	docker rm $(APP_NAME)
sr: ## Stop & Remove the hadoop container
	docker stop $(APP_NAME) && docker rm $(APP_NAME)
prune: ## Prune docker system
	docker system prune
exec: ## Connect to hadoop container shell
	docker exec -it hadoop bash
clean: ## Clean dfs volume
	rm -rf data/hadoop/{nameNode,dataNode}
net: ## Create Network used by hadoop
	docker network create --driver bridge ${NETWORK}
# https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db