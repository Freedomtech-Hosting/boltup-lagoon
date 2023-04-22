ARG BOLTUPBASE_IMAGE
FROM ${BOLTUPBASE_IMAGE}

# Make the CLI friendly
RUN apk add --no-cache git \
        unzip \
        gzip  \
        bash \
        openssh-client \
        rsync \
        patch \
        procps \
        coreutils \
        findutils \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /home/.ssh \
    && fix-permissions /home/

ENV LND_RELEASE_VER "v0.16.0-beta"
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_RELEASE_VER}/lnd-linux-amd64-${LND_RELEASE_VER}.tar.gz -O /tmp/lnd.tar.gz \
	&& tar -zxvf /tmp/lnd.tar.gz -C /tmp --strip-components=1

RUN mv /tmp/lnd /usr/bin && fix-permissions /usr/bin/lnd
RUN mv /tmp/lncli /usr/bin && fix-permissions /usr/bin/lncli

# Continue with Lagoon work
WORKDIR /app
RUN mkdir /app/storage/lnd \
	&& fix-permissions /app/storage/lnd

# Add an entrypoint that starts TOR
COPY lnd/entrypoints/99-entrypoint-lnd.sh /lagoon/entrypoints/

#CMD ["/usr/bin/lnd"]
