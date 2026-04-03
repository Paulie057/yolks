FROM ghcr.io/parkervcp/yolks:debian

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEDEBUG=-all
ENV DISPLAY=:0

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
        wine64 \
        wine32 \
    && rm -rf /var/lib/apt/lists/*

USER container
WORKDIR /home/container
