#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- influxd "$@"
fi

if [ "$1" = 'influxd' ]; then
	set -- "$@"
fi

exec "$@"