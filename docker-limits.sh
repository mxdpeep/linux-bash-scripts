#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

TOKEN=$(curl --silent "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
curl --silent --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest
