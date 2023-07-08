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
    LND_WALLETPASSWORD=freedomtech \
    LND_DEBUG_LEVEL=info

ENV LND_BTCD_RPCCERT -----BEGIN CERTIFICATE-----\\nMIICujCCAhugAwIBAgIQbet3ZTwT/tHMtQIDwabfbzAKBggqhkjOPQQDBDA4MRww\\nGgYDVQQKExNGcmVlZG9tVGVjaC5Ib3N0aW5nMRgwFgYDVQQDEw9pcC0xNzItMjYt\\nMTAtNzIwHhcNMjMwNzA3MTUzMzA1WhcNMzMwNzA1MTUzMzA1WjA4MRwwGgYDVQQK\\nExNGcmVlZG9tVGVjaC5Ib3N0aW5nMRgwFgYDVQQDEw9pcC0xNzItMjYtMTAtNzIw\\ngZswEAYHKoZIzj0CAQYFK4EEACMDgYYABADlXuysI+2mELWagaIp6JS2DuctXeoe\\n9c8qKJhajR7+AsQzeoEmF4eyXFT/j8hMMuhQf+pAsYfRjCfzhmecEubD8gGFHHEx\\nynPMxg0CpPtg1qdUHyRS40Z0OLOHoYaKOBCScPkFarAqJs3oy+Y3Ibo0QEEt+rZF\\nUhsuIYWAfC8Iaeh1mKOBwzCBwDAOBgNVHQ8BAf8EBAMCAqQwDwYDVR0TAQH/BAUw\\nAwEB/zAdBgNVHQ4EFgQULDf11971b0UIbkVxtWMnUT3RFScwfgYDVR0RBHcwdYIP\\naXAtMTcyLTI2LTEwLTcygglsb2NhbGhvc3SCFWJ0Y2QudXMuY3J5cHNvbml0ZS5p\\nb4cEfwAAAYcQAAAAAAAAAAAAAAAAAAAAAYcErBoKSIcQJgAfGEHXhwA8Xs19lcfn\\n2ocQ/oAAAAAAAAAMJ5D//ldvdzAKBggqhkjOPQQDBAOBjAAwgYgCQgE4Aoj0IbcS\\nc0ar/3EQt+0MgQiqkjvBM1MYHvT9IpAWZFROz/w9MLcIJHOs6KMGtMADhvrO8dN+\\nzfLwY2lnPkXZTgJCAdAYLKs4r4LqaDiBngqey++g3udDHM8FcA8SovvzOH/5etMD\\nkf7rheSBXn/6KuZ//Oy8R2r9kFBA7IUybPRKLhO+\\n-----END CERTIFICATE-----

# Add a supervisor config for LND
COPY lnd/supervisor-lnd.conf /etc/supervisor/conf.d/

# lndinit has an entrypoint which we don't need, overwrite it
ENTRYPOINT [""]

CMD ["supervisord", "--configuration", "/etc/supervisord.conf"]
