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

sh -c "${BASE_DIR}/deploy-config.sh"
sh -c "${BASE_DIR}/deploy-secret.sh"
docker network create -d overlay --attachable monitoring >/dev/null 2>&1 || true
docker stack deploy --compose-file monitoring.yml monitoring
docker stack deploy --compose-file atsea.yml atsea
docker stack deploy --compose-file openfaas.yml openfaas

cat << EOF
                  ##          .
            ## ## ##         ==
         ## ## ## ##        ===
     /""""""""""""""""\___/ ===
~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
     \______ o          __/
       \    \        __/
        \____\______/
EOF
echo ""
echo "portainer:     http://localhost:9000"
echo "openfaas:      http://localhost:8080"
echo "atsea demo:    http://localhost:8000"
echo "grafana:       http://localhost:3000"
echo "prometheus:    http://localhost:9090"