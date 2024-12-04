#!/bin/bash

if find ./.fdum/ -mindepth 1 -maxdepth 1 | read; then
  echo "dir not empty"
else
  echo "dir empty"
fi
