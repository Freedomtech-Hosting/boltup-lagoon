FROM uselagoon/commons as commons
FROM lightninglabs/lndinit:v0.1.13-beta-lnd-v0.16.3-beta

COPY --from=commons /bin/ep /bin/fix-permissions /bin/

#######################################################################
# BoltUp Base
#######################################################################
WORKDIR /app

# Install Supervisord
RUN apk add --update --no-cache supervisor
ADD supervisor/supervisord.conf /etc/

#######################################################################
# Tor and related tools
#######################################################################

# Install TOR
RUN apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        --allow-untrusted tor

# We need some custom TOR configs
COPY tor/torrc /etc/tor/torrc

# Add a supervisor config for TOR
COPY tor/supervisor-tor.conf /etc/supervisor/conf.d/

#######################################################################
# LND config
#######################################################################

RUN ln -s /app/storage/lnd /.lnd

COPY lnd/lnd.conf /app

RUN fix-permissions /app/lnd.conf

COPY lnd/init-wallet.sh /

ENV BITCOIN_NETWORK=testnet \
    LND_ALIAS=lnd-node-1 \
    LND_WALLETPASSWORD=freedomtech

# Add a supervisor config for LND
COPY lnd/supervisor-lnd.conf /etc/supervisor/conf.d/

# lndinit has an entrypoint which we don't need, overwrite it
ENTRYPOINT [""]

CMD ["supervisord", "--configuration", "/etc/supervisord.conf"]
