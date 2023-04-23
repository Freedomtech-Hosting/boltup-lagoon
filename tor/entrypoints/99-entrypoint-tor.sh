#!/bin/sh
set -e

echo Checking for any TOR specific entrypoint requirements

if [ ! -d "/app/storage/tor" ]; then
	mkdir -p /app/storage/tor
	mkdir -p /app/storage/tor/data
fi
