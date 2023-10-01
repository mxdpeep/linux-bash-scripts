#!/bin/bash

if [ -z "$3" ]; then
  echo -e "\nPing network range\n\nSyntax: $(basename $0) <subnet> <low> <hi>\nExample: $(basename $0) 192.168.1 1 10\n\n"
  exit 1
fi

is_alive_ping() {
  local IP="$NETWORK.$1"
  echo -e "Pinging "$IP"        \033[1A"
  ping -c 1 -w 1 $IP >/dev/null
  [ $? -eq 0 ] && echo ▶ $IP is up
}

echo -e "\nPinging the network:\n"

NETWORK=$1
LO=$2
HI=$3

for i in `seq $LO $HI`; do is_alive_ping $i; done
