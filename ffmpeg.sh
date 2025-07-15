#!/bin/bash

set -x
docker run --rm -v "$(pwd):/config" -w /config lscr.io/linuxserver/ffmpeg:latest "$@"
