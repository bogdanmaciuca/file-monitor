#!/bin/sh
if [ $# = 1 ]; then
elif [ $# = 2 ]; then
    echo "2 arguments!"
elif [ $# = 3 ]; then
    echo "3 arguments!"
else
    echo "Wrong number of arguments!"
fi
