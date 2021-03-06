#!/bin/bash

# bail if err
set -e

# Make sure we know where we are
if [ -z "${BASE_DIR}" ]; then
## Get the absolute working directory
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
    export BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
fi

for file in ${BASE_DIR}/config/*; do
    echo "processing: ${file}"
    if [ -f ${file} ]; then
        fileName=${file##*/}
        baseName=${fileName%.*}

        if [ ! -z $(docker config ls -q --filter name=${baseName} > /dev/null 2>&1) ]; then
            docker config rm ${baseName} 2>&1 || true
        fi

        docker config create $baseName $file > /dev/null 2>&1 || true
    fi;
done
