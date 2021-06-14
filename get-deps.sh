#!/bin/sh

SYSTEM_NAME=$1

docker build . --rm -t "$SYSTEM_NAME" --build-arg SYSTEM_NAME="$SYSTEM_NAME"
docker create --name "$SYSTEM_NAME" "$SYSTEM_NAME" bash
docker cp "$SYSTEM_NAME":/home/lisp/quicklisp/dists/quicklisp/software/ lisp-systems/
docker rm "$SYSTEM_NAME"
docker rmi "$SYSTEM_NAME"
