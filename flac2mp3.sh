#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nConvert FLAC files to MP3 recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi

which flac >/dev/null 2>&1 || (echo "Installing flac" && sudo apt-get install -yqq flac)
which flac >/dev/null 2>&1 || (echo "ERROR: flac is not installed" && exit 1)
which lame >/dev/null 2>&1 || (echo "Installing lame" && sudo apt-get install -yqq lame)
which lame >/dev/null 2>&1 || (echo "ERROR: lame is not installed" && exit 1)

if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo "Invalid folder: $1"
    exit 1
  fi
fi

for i in *
do
  if [ -d "$i" ]; then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
done

for i in *.flac
do
  if [ -f "$i" ]; then
    echo "Converting: $i"
    j="${i%.flac}"
    flac -d "$i"
    lame -h --preset extreme "$j.wav" "$j.mp3"
    if [ $? -eq 0 ]; then
      echo "Successfully converted: $i"
      rm -f "$i" "$j.wav"
    else
      echo "ERROR: Failed to convert: $i"
    fi
  fi
done

echo -e "Done.\n"
