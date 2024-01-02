FROM uselagoon/commons as commons
FROM lightninglabs/lndinit:v0.1.13-beta-lnd-v0.16.3-beta

COPY --from=commons /bin/ep /bin/fix-permissions /bin/

WORKDIR /app

RUN ln -s /app/storage/lnd /.lnd

COPY lnd/lnd.conf /app

RUN fix-permissions /app/lnd.conf

COPY lnd/start-lnd.sh /

ENV BITCOIN_NETWORK=testnet \
    LND_ALIAS=lnd-node-1 \
    LND_WALLETPASSWORD=freedomtech \
    LND_DEBUG_LEVEL=info

ENTRYPOINT ["/start-lnd.sh"]
CMD ["--lnddir=/app/storage/lnd", "--configfile=/app/lnd.conf"]
