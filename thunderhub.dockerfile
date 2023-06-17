FROM uselagoon/commons as commons
FROM apotdevin/thunderhub:v0.13.19

COPY --from=commons /bin/fix-permissions /bin/ep /bin/

COPY thunderhub/thubConfig.yaml /thubConfig.yaml

RUN fix-permissions /app/src/client/.next/cache/ \
    && fix-permissions /thubConfig.yaml

ENV BITCOIN_NETWORK=testnet \
    LND_ALIAS=lnd-node-1 \
    ACCOUNT_CONFIG_PATH=/thubConfig.yaml \
    LND_WALLETPASSWORD=freedomtech

CMD [ "sh", "-c", "ep /thubConfig.yaml && node dist/main" ]