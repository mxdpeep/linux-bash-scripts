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

# parameters
if [ $# -eq 0 ]; then dom="all"; fi
if [ $# -eq 1 ]; then dom=$1; fi
if [ $# -gt 1 ]; then info "\nUsage: \t$0 [<domain.tld>]\n\n"; exit; fi

# list all zones (max. 50)
if [ -f "/tmp/cf-zones.txt" ]; then r=$(cat "/tmp/cf-zones.txt"); else
  r=$(curl -s -X GET "${CF_API}/zones?status=active&page=${PAGE}&per_page=${PER_PAGE}&match=all" \
     -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
  echo $r > "/tmp/cf-zones.txt"
fi
names=$(echo $r|jq ".result[].name"|sed 's/"//g')
count=$(echo $names|sed 's/ /\n/g'|wc -l)

# multiple domains or single one
if [ "$dom" == "all" ]
then
  yes_or_no "Process $count zone(s) and purge edge cache for all of them?" || exit 1
else
  echo "Searching for \"$dom\" zone ..."
fi

j=0
for i in $names
do
  ((j++))
  if [ "$dom" != "all" ]; then if [ "$dom" != "$i" ]; then continue; fi; fi

  # get current zone
  r=$(curl -s -X GET "${CF_API}/zones?name=${i}&status=active&page=1&per_page=1&match=all" \
     -H "Authorization: Bearer ${CF_TOKEN}" \
     -H "Content-Type: application/json")
  id=$(echo $r|jq ".result[].id"|sed 's/"//g')
  name=$(echo $r|jq ".result[].name"|sed 's/"//g')

  # purge cache
  r=$(curl -s -X POST "${CF_API}/zones/${id}/purge_cache" \
    -H "Authorization: Bearer ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}')
  result=$(echo $r|jq ".success")

  # check result
  if [ "$result" == "true" ]; then
    echo -en "$j/$count "
    infogreen "${name}"
    if [ "$dom" != "all" ]; then exit 0; fi
  else
    echo -en "$j/$count "
    infored "${name}"
  fi

done

if [ "$dom" != "all" ]; then echo "Not found!"; exit 1; fi
