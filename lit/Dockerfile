FROM uselagoon/commons as commons
FROM lightninglabs/lightning-terminal:v0.10.1-alpha

COPY --from=commons /bin/fix-permissions /bin/ep /bin/

COPY lit.conf /home/lit.conf

RUN fix-permissions /home

ENV LIT_DEBUG_LEVEL=info \
    BITCOIN_NETWORK=testnet \
    LND_WALLETPASSWORD=freedomtech \
    HOME=/home

# lightning-terminal has an entrypoint which we don't need, overwrite it
ENTRYPOINT [""]

CMD [ "sh", "-c", "ep /home/lit.conf && litd --configfile=/home/lit.conf" ]