#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nConvert M4A files to MP3 recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi
if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo -e "Invalid folder: $1\n"
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

for i in *; do
  if [ -d "$i" ]; then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
done

for i in *.m4a; do
  if [ -f "$i" ]; then
    echo "Converting: $i"
    ffmpeg -i "${i%.m4a}.m4a" -codec:v copy -codec:a libmp3lame -q:a 0 "${i%.m4a}.mp3"
    rm -f "$i"
  fi
done

echo -e "Done.\n"

exit 0
