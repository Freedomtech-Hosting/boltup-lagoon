#!/bin/bash

set -e

if [[ ! -d /app/storage/lnd ]]; then
    mkdir -p /app/storage/lnd
fi

if [[ ! -f /app/storage/seed.txt ]]; then
    lndinit gen-seed > /app/storage/seed.txt
fi

if [[ ! -f /app/storage/walletpassword.txt ]]; then
    lndinit gen-password > /app/storage/walletpassword.txt
fi

lndinit -v init-wallet \
    --secret-source=file \
    --file.seed=/app/storage/seed.txt \
    --file.wallet-password=/app/storage/walletpassword.txt \
    --init-file.output-wallet-dir=/.lnd/data/chain/bitcoin/testnet \
    --init-file.validate-password

# And finally start lnd. We need to use "exec" here to make sure all signals are
# forwarded correctly.
echo ""
echo "[STARTUP] Starting lnd with flags: $@"
exec lnd "$@"