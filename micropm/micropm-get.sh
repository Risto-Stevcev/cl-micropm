#!/bin/sh

SYSTEM_NAME=$1

docker build -f ./micropm-docker/Dockerfile "$USER_PWD" --rm -t "$SYSTEM_NAME" --build-arg SYSTEM_NAME="$SYSTEM_NAME"
docker create --name "$SYSTEM_NAME" "$SYSTEM_NAME" bash
docker cp "$SYSTEM_NAME":/home/lisp/quicklisp/dists/quicklisp/software/ lisp-systems/
docker rm "$SYSTEM_NAME"
docker rmi "$SYSTEM_NAME"

test -d lisp-systems && \
  cp -r lisp-systems "$USER_PWD"
cp .envrc "$USER_PWD"
