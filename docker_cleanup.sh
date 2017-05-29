#!/bin/sh

docker ps -aq -f status=dead -f status=exited			|xargs -r docker rm -v
docker images --no-trunc | grep '<none>' | awk '{print $3}'	|xargs -r docker rmi
docker volume ls -q -f dangling=true				|xargs -r docker volume rm
