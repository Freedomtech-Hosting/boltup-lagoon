FROM uselagoon/commons:latest

#######################################################################
# BoltUp Base
#######################################################################
WORKDIR /app

RUN mkdir /app/storage && fix-permissions /app/storage

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
# LND and related tools
#######################################################################
# Install LND
ENV LND_RELEASE_VER "v0.16.0-beta"
RUN wget https://github.com/lightningnetwork/lnd/releases/download/${LND_RELEASE_VER}/lnd-linux-amd64-${LND_RELEASE_VER}.tar.gz -O /tmp/lnd.tar.gz \
	&& tar -zxvf /tmp/lnd.tar.gz -C /tmp --strip-components=1 \
    && mv /tmp/lnd /usr/bin && chmod +x /usr/bin/lnd \
    && mv /tmp/lncli /usr/bin && chmod +x /usr/bin/lncli \
    && rm -rf /tmp/*


RUN ln -s /app/storage/lnd /home/.lnd

COPY lnd/lnd.conf /app

# Add a supervisor config for LND
COPY lnd/supervisor-lnd.conf /etc/supervisor/conf.d/



CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
