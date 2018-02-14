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

configList=$(find ${BASE_DIR}/config -type f)

echo $configList

exit

for file in ${WORK_DIR}/${CONFIG_PATH}/*; do
    foPrintLine "processing: ${file}"
    if [ -f ${file} ]; then
        fileName=${file##*/}
        baseName=${fileName%.*}

        if [ ! -z $(docker config ls -q --filter name=${baseName}) ]; then
            foPrintLine "removing: ${baseName}" "yellow"

            result=$(docker config rm ${baseName} 2>&1) || handleError "delete" ${result} ${baseName}
        fi

        foPrintLine "creating: ${baseName} [${CONFIG_PATH}/${fileName}]" "green"

        result=$(docker config create $LABELS_JOINED $baseName $file 2>&1) || handleError "create" ${result} ${baseName}
    fi;
done
