#!/bin/bash

DOCKER_IMAGE="lscr.io/linuxserver/ffmpeg:latest"
HOST_CWD="$(pwd)"
CONTAINER_MEDIA_DIR="/config"

docker run \
  --rm \
  -it \
  -v "${HOST_CWD}:${CONTAINER_MEDIA_DIR}" \
  "${DOCKER_IMAGE}" \
  ffmpeg "$@"

# docker run --rm -it \
#  -v $(pwd):/config \
#  linuxserver/ffmpeg \
#  -i /config/input.mkv \
#  -c:v libx264 \
#  -b:v 4M \
#  -vf scale=1280:720 \
#  -c:a copy \
#  /config/output.mkv
