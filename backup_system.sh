#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

TMP="/1TB/SYSTEM_BACKUP"
rm -rf $TMP
mkdir $TMP

date

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

cd ~

for i in .vst .vst3 .u-he .lv2 .clap
do
  echo $i
  if [ ! -d "$i" ]; then continue; fi
  date=$(date '+%Y-%m-%d')
  name="${TMP}/home${i}_${date}.tgz"
  echo $name
  tar czf "$name" "./$i"
done

rclone move -P $TMP/ gsc:SYSTEM_BACKUP/
date
