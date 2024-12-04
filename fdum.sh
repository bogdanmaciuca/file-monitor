#!/bin/sh

fdum_init() {
  if [ ! -d ".fdum" ]; then
    mkdir .fdum
    echo "Directory .fdum created."
  else
    echo "Directory .fdum already exists."
    #if find ./.fdum/ -mindepth 1 -maxdepth 1 | read; then
    #  echo "dir not empty"
    #else
    #  echo "dir empty"
    #fi
  fi
}

if [ $# = 1 ]; then
    if [ "$1" = "init" ]; then
        fdum_init
    elif [ "$1" = "diff" ]; then
        echo "diff take either 1 or 2 arguments"
    elif [ "$1" = "snapshot" ]; then
        fdum_snap
    else
        echo "Unknown argument: $1"
    fi
elif [ $# = 2 ]; then
    echo "2 arguments!"
elif [ $# = 3 ]; then
    echo "3 arguments!"
else
    echo "Wrong number of arguments!"
fi
