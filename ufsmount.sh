#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

cd "$(dirname "$0")"
export PATH=$PATH:/snap/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$PATH:$HOME/go/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/scripts

function disconnect {
  cd ~/
  echo $1
  fusermount -u $1
}

disconnect DS1
disconnect DS2
disconnect DS3

disconnect GSC

#disconnect HMCSFX
#disconnect INGAME
#disconnect SFX

#disconnect KONTAKT1
#disconnect KONTAKT2
#disconnect KONTAKT3

#disconnect SAMPLES1
#disconnect SAMPLES2
#disconnect SAMPLES3

disconnect STORAGEBOX storagebox:
disconnect VIETCONG vietcong:
