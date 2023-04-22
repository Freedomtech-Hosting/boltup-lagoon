FROM uselagoon/commons:latest

WORKDIR /app

RUN fix-permissions /etc/passwd \
    && mkdir -p /home \
    && fix-permissions /home \
    && mkdir -p /app \
    && fix-permissions /app

ENV TMPDIR=/tmp \
    TMP=/tmp \
    HOME=/home \
    # When Bash is invoked via `sh` it behaves like the old Bourne Shell and sources a file that is given in `ENV`
    ENV=/home/.bashrc \
    # When Bash is invoked as non-interactive (like `bash -c command`) it sources a file that is given in`BASH_ENV`
    BASH_ENV=/home/.bashrc

RUN apk update 

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
        openssl \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /home/.ssh \
    && fix-permissions /home/

# We not only use "export $PATH" as this could be overwritten again
# like it happens in /etc/profile of alpine Images.
COPY boltupbase/entrypoints /lagoon/entrypoints/

# Make sure shells are not running forever
RUN echo "source /lagoon/entrypoints/80-shell-timeout.sh" >> /home/.bashrc

# SSH Key and Agent Setup
COPY boltupbase/ssh_config /etc/ssh/ssh_config
# COPY id_ed25519_lagoon_cli.key /home/.ssh/lagoon_cli.key
# RUN chmod 400 /home/.ssh/lagoon_cli.key
ENV SSH_AUTH_SOCK=/tmp/ssh-agent

RUN mkdir /app/storage && fix-permissions /app/storage

# Install Supervisord
RUN apk add --update supervisor && rm  -rf /tmp/* /var/cache/apk/*
ADD boltupbase/supervisord.conf /etc/
RUN mkdir -p /etc/supervisor/conf.d/ && fix-permissions /etc/supervisor/conf.d
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

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

# Add an entrypoint for TOR
COPY tor/entrypoints/99-entrypoint-tor.sh /lagoon/entrypoints/

# Add a supervisor config for TOR
COPY tor/supervisor-tor.conf /etc/supervisor/conf.d/

# Add a tor check command
COPY tor/check-tor /usr/bin

# Install LND
ENV LND_RELEASE_VER "v0.16.0-beta"
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_RELEASE_VER}/lnd-linux-amd64-${LND_RELEASE_VER}.tar.gz -O /tmp/lnd.tar.gz \
	&& tar -zxvf /tmp/lnd.tar.gz -C /tmp --strip-components=1

RUN mv /tmp/lnd /usr/bin && fix-permissions /usr/bin/lnd
RUN mv /tmp/lncli /usr/bin && fix-permissions /usr/bin/lncli

RUN mkdir /app/storage/lnd \
	&& fix-permissions /app/storage/lnd

# Add an entrypoint that for LND
COPY lnd/entrypoints/99-entrypoint-lnd.sh /lagoon/entrypoints/
COPY lnd/lnd.conf /app

# Add a supervisor config for LND
COPY lnd/supervisor-lnd.conf /etc/supervisor/conf.d/
