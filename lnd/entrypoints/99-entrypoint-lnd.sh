#!/bin/sh
set -e

echo Checking for any LND specific entrypoint requirements

if [ ! -d "/app/storage/lnd" ]; then
	mkdir -p /app/storage/lnd
fi
