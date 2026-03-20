FROM ghcr.io/openclaw/openclaw:main

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

RUN apt update && apt install -y \
    ca-certificates \
    curl \
    git \
    vim \
    x11-apps \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-ipafont \
    python3-pip \
    python3-venv \
    && fc-cache -fv \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["bash"]
