#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/scripts

docker rm redis --force
docker run -dit --restart unless-stopped -p 6377:6379 --ulimit nofile=50000:50000 --name redis redis:latest

docker rm redisearch --force
docker run -dit --restart unless-stopped -p 6378:6379 --ulimit nofile=50000:50000 --name redisearch redislabs/redisearch:latest
