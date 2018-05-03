#!/bin/bash
build() {
    docker build -t $1 -f $1.dockerfile .
}

if [ $# -eq 0 ]; then
    build codes-core
    build codes-storage
    build codes-vis
else
    for i in $*; do 
        build $i 
    done
fi