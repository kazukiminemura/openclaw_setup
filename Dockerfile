FROM ghcr.io/openclaw/openclaw:main

ARG APP_USER=appuser
ARG THREADS2SPREAD_REPO=https://github.com/kazukiminemura/threads2spread.git

USER root

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    APP_HOME=/home/${APP_USER} \
    THREADS2SPREAD_DIR=/home/${APP_USER}/threads2spread \
    VIRTUAL_ENV=/home/${APP_USER}/threads2spread/.venv \
    PATH=/home/${APP_USER}/threads2spread/.venv/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && useradd -m -s /bin/bash "${APP_USER}" \
    && install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_HOME}/.openclaw/workspace" "${PLAYWRIGHT_BROWSERS_PATH}" \
    && npm install -g playwright \
    && playwright install chromium \
    && git clone "${THREADS2SPREAD_REPO}" "${THREADS2SPREAD_DIR}" \
    && python3 -m venv "${VIRTUAL_ENV}" \
    && "${VIRTUAL_ENV}/bin/pip" install --upgrade pip \
    && "${VIRTUAL_ENV}/bin/pip" install -r "${THREADS2SPREAD_DIR}/requirements.txt" \
    && "${VIRTUAL_ENV}/bin/python" -m playwright install-deps chromium \
    && "${VIRTUAL_ENV}/bin/python" -m playwright install chromium \
    && touch "${THREADS2SPREAD_DIR}/.playwright-browser-installed" \
    && touch "${THREADS2SPREAD_DIR}/.playwright-deps-installed" \
    && touch "${THREADS2SPREAD_DIR}/.playwright-installed" \
    && fc-cache -fv \
    && chown -R "${APP_USER}:${APP_USER}" "${APP_HOME}" "${PLAYWRIGHT_BROWSERS_PATH}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER ${APP_USER}
WORKDIR ${THREADS2SPREAD_DIR}


CMD ["bash"]
