#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

if [ $# -eq 0 ]; then
  echo -e "\nAdd gfx subtitles to the video.\n\nSyntax: $(basename $0) <video_filename>\n"
  exit 1
fi
if [ -n "$1" ]; then
  if [ -f "$1" ]; then
    fn=$(basename -- "$1")
    fn="${fn%.*}"
    if [ -f "$fn.srt" ]; then
      echo "Processing: $1 $fn.srt"
      sleep 1
      ffmpeg -i "$1" -vf subtitles="$fn.srt" "titulky_$1"
    else
      echo "Missing SRT file!"
      exit 1
    fi
  else
    echo "Invalid filename: $1"
    exit 1
  fi
fi

exit 0
