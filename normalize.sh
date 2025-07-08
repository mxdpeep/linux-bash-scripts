#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nNormalizes video volume\n\nSyntax: $(basename $0) <video_filename>\n"
  exit 1
fi

which ffmpeg >/dev/null 2>&1 || (echo "Installing ffmpeg" && sudo apt-get install -yqq ffmpeg)
which ffmpeg >/dev/null 2>&1 || (echo "ERROR: ffmpeg is not installed" && exit 1)

if [ -n "$1" ]; then
  if [ -f "$1" ]; then
    ffmpeg -i "$1" -c:v copy -af "loudnorm" "normalized_$1"
  else
    echo "Invalid filename: $1"
    exit 1
  fi
fi

echo -e "Done.\n"
