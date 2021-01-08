#!/usr/bin/env bash
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=techforum
# image name
IMAGE=httpd-extended
docker build --no-cache -t $USERNAME/$IMAGE:latest .