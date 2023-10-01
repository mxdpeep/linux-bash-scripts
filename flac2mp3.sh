#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nConvert FLAC files to MP3 recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi
if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo "Invalid folder: $1"
    exit 1
  fi
fi

which flac >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing flac"
  sudo apt-get install -yqq flac
fi
which flac >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "ERROR: flac is not installed"
  exit 1
fi
which lame >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing lame"
  sudo apt-get install -yqq lame
fi
which lame >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "ERROR: lame is not installed"
  exit 1
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
    rm -f "$i" "$j.wav"
  fi
done

echo -e "Done.\n"

exit 0
