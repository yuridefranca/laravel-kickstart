#!/usr/bin/env bash

export $(grep -v '^#' .env | xargs)

while getopts r: argument; do
	case "${argument}" in
	r) remove=${OPTARG} ;;
	esac
done

function removeNodeModules() {
	sudo rm -rf www/node_modules
}

function removeDockerImage() {
	docker rmi "$PROJECT_NAME/php*"
}

docker-compose down -v

if [ "$remove" == "node_modules" ]; then
	removeNodeModules
elif [ "$remove" == "image" ]; then
	removeDockerImage
elif [ "$remove" == "all" ]; then
	removeDockerImage
	removeNodeModules
fi