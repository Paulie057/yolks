FROM ghcr.io/parkervcp/yolks:debian

LABEL author="Daniel Hruska"
LABEL maintainer="daniel@enoahost.cz"

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV DISPLAY=:99

USER root

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        unzip \
        xz-utils \
        file \
        xvfb \
        winbind \
        cabextract \
        procps \
        net-tools \
        iproute2 \
        lib32gcc-s1 \
        libc6:i386 \
        libstdc++6:i386 \
        wine \
        wine64 \
        wine32 \
        libwine \
        libwine:i386 \
        fonts-wine \
        libntlm0 \
        gnutls-bin \
        libsqlite3-0 \
    && mkdir -p /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix \
    && if [ -x /usr/bin/wine64 ]; then ln -sf /usr/bin/wine64 /usr/local/bin/wine64; fi \
    && if [ -x /usr/bin/wine ]; then ln -sf /usr/bin/wine /usr/local/bin/wine; fi \
    && rm -rf /var/lib/apt/lists/*

RUN cat <<'EOF' > /entrypoint.sh
#!/bin/bash
set -e

cd /home/container

echo ":/home/container$ ${STARTUP}"

exec /bin/bash -lc "${STARTUP}"
EOF

RUN chmod +x /entrypoint.sh

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/entrypoint.sh"]
