#!/bin/bash

set -e

if [ -z "$1" ]
then
    echo "Supply a volume container name";
    exit 0;
fi
docker volume create $1 > /dev/null;
docker run -v $1:/data/ssl --name temp_volume_helper alpine true > /dev/null;
docker cp ssl/ temp_volume_helper:/data/ssl;
docker rm temp_volume_helper;
