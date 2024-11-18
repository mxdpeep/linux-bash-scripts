#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
cd $ABSDIR

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin
export PATH=$PATH:/root/bin:/root/go/bin:/root/.cargo/bin:/root/scripts

function rcli1 {
  docker exec -it redisearch redis-cli $1
}

function rcli2 {
  docker exec -it redis redis-cli $1
}

echo -ne "\n\n\e[32mRediSearch\e[0m\n"
rcli1 info | grep redis
echo -ne "\n"
rcli1 info | grep keys


echo -ne "\n\n\e[32mRedis\e[0m\n"
rcli2 info | grep redis
echo -ne "\n"
rcli2 info | grep keys
