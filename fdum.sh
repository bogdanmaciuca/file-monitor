#!/bin/sh

fdum_init() {
  if [ ! -d ".fdum" ]; then
    mkdir .fdum
    echo "Directory .fdum created."
  else
    echo "Directory .fdum already exists."
    if find ./.fdum/ -mindepth 1 -maxdepth 1 | read; then
      echo "dir not empty"
    else
      echo "dir empty"
    fi
  fi
}

if [ $# = 1 ]; then
elif [ $# = 2 ]; then
    echo "2 arguments!"
elif [ $# = 3 ]; then
    echo "3 arguments!"
else
    echo "Wrong number of arguments!"
fi
