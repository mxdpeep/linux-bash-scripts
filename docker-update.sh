#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
cd $ABSDIR

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin

docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
