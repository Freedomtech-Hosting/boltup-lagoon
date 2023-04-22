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


# Install Socat for SOCKS Proxy 
RUN apk add socat 

# Install TOR
RUN apk add --update-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
        --allow-untrusted --update tor \
    && rm -rf /var/cache/apk/*

# We need some custom TOR configs
COPY tor/torrc /etc/tor/torrc

RUN mkdir /app/storage/tor \
	&& mkdir /app/storage/tor/data \
	&& fix-permissions /app/storage/tor

# Add an entrypoint that starts TOR
COPY tor/entrypoints/99-entrypoint-tor.sh /lagoon/entrypoints/

CMD ["/usr/bin/tor"]
