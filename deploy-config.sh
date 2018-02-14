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

        if [ ! -z $(docker config ls -q --filter name=${baseName}) ]; then
            echo "attempting to remove: ${baseName}"

            docker config rm ${baseName} 2>&1 || true
        fi

        echo "attempting to create: ${baseName} [${BASE_DIR}/${fileName}]"

        docker config create $baseName $file || true
    fi;
done
