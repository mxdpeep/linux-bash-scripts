#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

date

TMP="/1TB/SYSTEM_BACKUP"

rm -rf $TMP
mkdir $TMP

cd ~/.config

for i in *
do
  # backup folders only
  if [ ! -d "$i" ]; then continue; fi
  date=$(date '+%Y-%m-%d')
  name="${TMP}/${i}_${date}.tgz"
  echo $name
  tar czf "$name" "./$i"
done

#rclone move -P $TMP/ mxd:SYSTEM_BACKUP/
rclone move -P $TMP/ gsc:SYSTEM_BACKUP/

date

exit 0

