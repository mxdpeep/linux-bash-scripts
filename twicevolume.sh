#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nUppends video volume by +6 dB\n\nSyntax: $(basename $0) <video_filename>\n"
  exit 1
fi

which ffmpeg >/dev/null 2>&1 || (echo "Installing ffmpeg" && sudo apt-get install -yqq ffmpeg)
which ffmpeg >/dev/null 2>&1 || (echo "ERROR: ffmpeg is not installed" && exit 1)

if [ -n "$1" ]; then
  if [ -f "$1" ]; then
    ffmpeg -i "$1" -c:v copy -af "volume=3dB" "volup2x_$1"
  else
    echo "Invalid filename: $1"
    exit 1
  fi
fi

echo -e "Done.\n"
