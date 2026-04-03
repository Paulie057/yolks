# Použijeme stabilní Debian základ od Pterodactylu
FROM ghcr.io/parkervcp/yolks:debian

LABEL author="Daniel Hruska"
LABEL maintainer="daniel@enoahost.cz"

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV DISPLAY=:99

USER root

# 1. Povolení 32bit architektury (nutné pro Wine a SteamCMD)
# 2. Instalace Wine a všech závislostí pro Rising Storm 2
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
    && rm -rf /var/lib/apt/lists/*

# OPRAVENO: Vytvoření entrypointu s ošetřením znaků $
RUN printf '#!/bin/bash\n\
cd /home/container\n\
# Převod Pterodactyl {{VAR}} na shell $VAR\n\
MODIFIED_STARTUP=$(echo -e "${STARTUP}" | sed -e "s/{{/\\${/g" -e "s/}}/}/g")\n\
echo ":/home/container\$ ${MODIFIED_STARTUP}"\n\
\n\
# Spuštění výsledného příkazu\n\
eval ${MODIFIED_STARTUP}' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Nastavení uživatele a pracovního adresáře
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Spuštění přes náš entrypoint
CMD ["/bin/bash", "/entrypoint.sh"]
