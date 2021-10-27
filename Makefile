
SHELL := /usr/bin/env bash

#######
# Help
#######

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

###################
# Conda Enviroment
###################

PY_VERSION := 3.9
CONDA_ENV_NAME ?= airflow-dbt
ACTIVATE_ENV = source activate ./$(CONDA_ENV_NAME)

.PHONY: build-conda-env
build-conda-env: $(CONDA_ENV_NAME)  ## Build the conda environment
$(CONDA_ENV_NAME):
	conda create -p $(CONDA_ENV_NAME)  --copy -y  python=$(PY_VERSION)
	$(ACTIVATE_ENV) && python -s -m pip install -r requirements.txt

###################
# DBT
###################
   
DBT_IMAGE_NAME := davidgasquez/dbt:latest

.PHONY: dbt-pull
dbt-pull:
	docker pull $(DBT_IMAGE_NAME)

.PHONY: dbt-version
dbt-version:
	docker run --rm -it $(DBT_IMAGE_NAME) dbt --version

.PHONY: dbt-config
dbt-config:
	docker run --rm -it $(DBT_IMAGE_NAME) dbt debug --config-dir
	docker run --rm -it $(DBT_IMAGE_NAME) cat /root/.dbt/*yml

.PHONY: dbt-build
dbt-build:
	docker build . --file ./docker/Dockerfile.dbt


###################
# Spin Up Docker
###################

.PHONY: docker-up
docker-up:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose.yml pull
	docker-compose -f docker-compose.yml up --build
