#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nConvert OGG files to WAV recursively.\n\nSyntax: $(basename $0) <folder>\n"
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

which ffmpeg >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing ffmpeg"
  sudo apt-get install -yqq ffmpeg
fi
which ffmpeg >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "ERROR: ffmpeg is not installed"
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

for i in *.ogg
do
  if [ -f "$i" ]; then
    echo "Converting: $i"
    j="${i%.ogg}"
    ffmpeg -i "$i" -vn "$j.wav"
    rm -f "$i"
  fi
done

echo -e "Done.\n"

exit 0
