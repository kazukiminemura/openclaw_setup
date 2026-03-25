FROM ghcr.io/openclaw/openclaw:main

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV APP_HOME=/home/appuser
ENV THREADS2SPREAD_DIR=/home/appuser/threads2spread
ENV VIRTUAL_ENV=/home/appuser/threads2spread/.venv
ENV PATH=/home/appuser/threads2spread/.venv/bin:$PATH

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
    && git clone https://github.com/kazukiminemura/threads2spread.git /home/appuser/threads2spread \
    && python3 -m venv /home/appuser/threads2spread/.venv \
    && /home/appuser/threads2spread/.venv/bin/pip install --upgrade pip \
    && /home/appuser/threads2spread/.venv/bin/pip install -r /home/appuser/threads2spread/requirements.txt \
    && /home/appuser/threads2spread/.venv/bin/python -m playwright install-deps chromium \
    && /home/appuser/threads2spread/.venv/bin/python -m playwright install chromium \
    && touch /home/appuser/threads2spread/.playwright-browser-installed \
    && touch /home/appuser/threads2spread/.playwright-deps-installed \
    && touch /home/appuser/threads2spread/.playwright-installed \
    && chown -R appuser:appuser /home/appuser /ms-playwright \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER appuser
WORKDIR /home/appuser/threads2spread


CMD ["bash"]
