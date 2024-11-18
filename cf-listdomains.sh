#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

CF_API="https://api.cloudflare.com/client/v4"
PAGE=1
PER_PAGE=50

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/scripts

. ./_includes.sh
if [ -f "./_cf_key.sh" ]; then . ./_cf_key.sh; fi
if [ -z "$CF_TOKEN" ]; then fail "Missing CF_TOKEN token value!"; fi;

# list all zones (max. 50)
if [ -f "/tmp/cf-zones.txt" ]; then r=$(cat "/tmp/cf-zones.txt"); else
  r=$(curl -s -X GET "${CF_API}/zones?status=active&page=${PAGE}&per_page=${PER_PAGE}&match=all" \
     -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
   echo $r > "/tmp/cf-zones.txt"
fi

echo $r|jq ".result[].name"|sort|sed 's/"//g'
