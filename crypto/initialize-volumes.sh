#!/bin/bash

set -e

docker volume create legit_ssl > /dev/null;
docker run -v legit_ssl:/data/ssl --name temp_volume_helper alpine true > /dev/null;
docker cp ssl/legit/ temp_volume_helper:/data/ssl/certs;
docker rm temp_volume_helper > /dev/null;

docker volume create evil_ssl > /dev/null;
docker run -v evil_ssl:/data/ssl --name temp_volume_helper alpine true > /dev/null;
docker cp ssl/evil/ temp_volume_helper:/data/ssl/certs;
docker rm temp_volume_helper > /dev/null;
