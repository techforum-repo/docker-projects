#!/usr/bin/env bash
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=techforum
# image name
IMAGE=tomcat-extended
docker build --no-cache -t $USERNAME/$IMAGE:latest .