.EXPORT_ALL_VARIABLES:

OS_NAME := $(shell uname -m)

# see https://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
THIS_FILE := $(lastword $(MAKEFILE_LIST))

# Docker CMD:
NOTEBOOK_DOCKER_CLI = docker compose  run --entrypoint=$(ENTRYPOINT) -it compvis
NOTEBOOK_DOCKER_START = docker compose up -d compvis && docker compose logs -f compvis
NOTEBOOK_DOCKER_BUILD = docker compose build compvis 

# Include other definitions
include *.mk
###########################
# PROJECT UTILS
###########################
build: ##@Utils Builds the docker images
	$(DOCKER_BUILD)

###########################
# JUPYTER
###########################
jupyter: ##@Jupyterlab Starts jupyterlab service
	@echo "Starting jupyter lab"
	$(NOTEBOOK_DOCKER_START)

clean: ##@Jupyterlab Cleans the compvis
	$(eval ENTRYPOINT := "/bin/bash -c 'ls . && cd ./work && jupyter nbconvert --clear-output --inplace Exercises/**/*.ipynb'")
	$(NOTEBOOK_DOCKER_CLI)

stop: ##@Jupyterlab Stops all services including the database
	@echo "Stop Jupyter lab, Mongo DB and MongoExpress..."
	docker compose down -v
