#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/scripts

mkdir -p /1TB/rclone

options="--vfs-cache-mode full --vfs-cache-max-age 12h --dir-cache-time 30m --buffer-size 512M --vfs-read-ahead 2048M --drive-chunk-size 256M --cache-dir /1TB/rclone --attr-timeout 3s --daemon"

function connect {
  cd ~/
  if [ ! -d "${1}" ]; then
    echo "Missing folder ${1} !!!"
    exit 1
  fi
  if [ -z "$(ls -A ${1})" ]; then
    TEST=$(rclone listremotes | grep "$2")
    if [ ! -z "$TEST" ]; then
      echo mounting $2 to $1
      rclone mount $options $2 $1 --daemon-wait 90s
    else
      echo -en "\n! rclone profile $2 does not exist !\n"
    fi
  fi
}

connect DS1 ds1:
connect DS2 ds2:
connect DS3 ds3:

connect GSC gsc:

#connect HMCSFX hmcsfx:
#connect INGAME ingame:
#connect SFX sfx:

#connect KONTAKT1 kontakt1:
#connect KONTAKT2 kontakt2:
#connect KONTAKT3 kontakt3:

#connect SAMPLES1 samples1:
#connect SAMPLES2 samples2:
#connect SAMPLES3 samples3:

connect STORAGEBOX storagebox:
connect VIETCONG vietcong:
