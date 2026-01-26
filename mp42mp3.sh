#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nConvert M4A files to MP3 recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi

which ffmpeg >/dev/null 2>&1 || (echo "Installing ffmpeg" && sudo apt-get install -yqq ffmpeg)
which ffmpeg >/dev/null 2>&1 || (echo "ERROR: ffmpeg is not installed" && exit 1)

if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo "Invalid folder: $1"
    exit 1
  fi
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
    ffmpeg -i "$i" -codec:v copy -codec:a libmp3lame -b:a 320k "${i%.m4a}.mp3"
    if [ $? -eq 0 ]; then
      echo "Successfully converted: $i"
      rm -f "$i"
    else
      echo "Failed to convert: $i"
    fi
  fi
done

echo -e "Done.\n"
