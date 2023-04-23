#!/bin/sh
set -e

echo Checking for any LND specific entrypoint requirements

if [ ! -d "/app/storage/lnd" ]; then
	echo Created the LND directory
	mkdir -p /app/storage/lnd
fi

if [ ! -f "/app/storage/lnd/wallet_password" ]; then
	echo Created a LND wallet password
	openssl rand -hex 21 > /app/storage/lnd/wallet_password
fi
