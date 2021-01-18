#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJ_DIR="$( dirname " $DIR ")"

touch .tmp
if [ "$1" == "$(cat .tmp)" ] ;then
    :
else
    echo "using" $1

    rm -rf $2
    git clone $1 $PROJ_DIR/$2

    echo $1 $2 > .tmp
fi