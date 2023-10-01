#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

docker exec -it redisearch redis-cli
