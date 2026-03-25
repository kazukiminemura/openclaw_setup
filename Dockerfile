FROM ghcr.io/openclaw/openclaw:main

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN apt update && apt install -y \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    vim \
    x11-apps \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-ipafont \
    python3-pip \
    python3-venv \
    libasound2 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxshmfence1 \
    && fc-cache -fv \
    && npm install -g playwright \
    && playwright install chromium \
    && useradd -m -s /bin/bash appuser \
    && mkdir -p /home/appuser/.openclaw/workspace \
    && chown -R appuser:appuser /home/appuser /ms-playwright \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER appuser
WORKDIR /home/appuser


CMD ["bash"]
