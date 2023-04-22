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

ENTRYPOINT ["/sbin/tini", "--", "/lagoon/entrypoints.sh"]
CMD ["/bin/docker-sleep"]
