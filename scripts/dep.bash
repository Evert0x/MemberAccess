#!/bin/bash

if [ "$1" == "$(cat .tmp)" ] ;then
    :
else
    echo "using" $1

    rm -rf $2
    git clone $1 $2

    echo $1 $2 > .tmp
fi