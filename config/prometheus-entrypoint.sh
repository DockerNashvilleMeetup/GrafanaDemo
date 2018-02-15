#!/bin/sh -e

mkdir -p /etc/prometheus/rules

set -- /bin/prometheus "$@"

exec "$@"
