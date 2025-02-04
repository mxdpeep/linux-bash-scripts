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
if [ $# -lt 2 ]; then info "\nUsage: \t$0 <all|domain.tld> <subdomain>\n\n"; exit; fi
if [ $# -eq 2 ]; then dom=$1; sub=$2; fi
if [ $# -gt 2 ]; then info "\nUsage: \t$0 <all|domain.tld> <subdomain>\n\n"; exit; fi

# list all zones (max. 50)
r=$(curl -s -X GET "${CF_API}/zones?status=active&page=${PAGE}&per_page=${PER_PAGE}&match=all" \
     -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
names=$(echo $r|jq ".result[].name"|sed 's/"//g')
count=$(echo $names|sed 's/ /\n/g'|wc -l)

# multiple domains or single one
if [ "$dom" == "all" ]
then
  yes_or_no "Process $count zone(s) and add \"$sub\" subdomain to all of them?" || exit 1
else
  echo "Searching for \"$dom\" zone ..."
fi

j=0
for i in $names
do
  ((j++))
  if [ "$dom" != "all" ]; then if [ "$dom" != "$i" ]; then continue; fi; fi

  # get current zone
  r=$(curl -s -X GET "${CF_API}/zones?name=${i}&status=active&match=all" \
     -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
  id=$(echo $r|jq ".result[].id"|sed 's/"//g')
  name=$(echo $r|jq ".result[].name"|sed 's/"//g')

  # get record ID for deletion
  r=$(curl -s -X GET "${CF_API}/zones/${id}/dns_records?name=${sub}.${name}&match=all" \
    -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
  rec=$(echo $r|jq ".result[].id"|sed 's/"//g')
  if [ "$rec" == "" ]; then infored "${name} * record ${sub}.${name} not found"; continue; fi

  # delete record
  r=$(curl -s -X DELETE "${CF_API}/zones/${id}/dns_records/${rec}" \
    -H "Authorization: Bearer ${CF_TOKEN}" -H "Content-Type: application/json")
  result=$(echo $r|jq ".success")

  # check result
  if [ "$result" == "true" ]; then
    echo -en "$j/$count "
    infogreen "${name}"
    info "- record: ${sub}"
  else
    echo -en "$j/$count "
    infored "${name}"
    echo $r|jq ".errors[].message"
  fi

done
