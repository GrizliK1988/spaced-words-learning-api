#!/usr/bin/env bash

containerName="cousine-app"
hostUserId=$(id -u)
dockerUser=www-data

uid=$(id -u)
if [ $uid -gt 100000 ]; then
    uid=1000
fi

sed "s/\$USER_ID/$uid/g" ./docker/php/Dockerfile.dist > ./docker/php/Dockerfile

#stop potentially running app
docker-compose stop

##build and launch containers
docker-compose build
docker-compose up -d

##composer selfupdate
docker exec -it $containerName composer selfupdate

# setup permissions
docker exec $containerName chown -R $dockerUser:$dockerUser /var/www

##log into the container
# docker exec -it --user $dockerUser $containerName bash
# docker-compose stop