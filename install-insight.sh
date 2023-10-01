#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

docker rm redisinsight --force
docker run -v redisinsight:/db -p 7777:8001 --name redisinsight -d redislabs/redisinsight
