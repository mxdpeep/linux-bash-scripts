#!/bin/bash
# @author Fred Brooker <git@gscloud.cz>

# Trap Ctrl+C (SIGINT) to perform a graceful exit
trap 'echo -e "\n\e[31mScript terminated by user (Ctrl+C).\e[0m"; exit 1' SIGINT

set -x
docker run --rm --cpus "8.0" -v "$(pwd):/config" -w /config lscr.io/linuxserver/ffmpeg:latest "$@"
exit $?
