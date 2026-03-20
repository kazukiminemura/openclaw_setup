
# 🐳 OpenClaw on Ubuntu（Docker構成図）

```
+------------------------------------------------------+
|                  🖥 Ubuntu Host                       |
|------------------------------------------------------|
|                                                      |
|  +-----------------------------------------------+   |
|  |               Docker Engine                   |   |
|  |-----------------------------------------------|   |
|  |                                               |   |
|  |  +-------------------+     +----------------+  |   |
|  |  |  openclaw         |     | openclaw-gw    |  |   |
|  |  |  (main app)       |     | (gateway)      |  |   |
|  |  |-------------------|     |----------------|  |   |
|  |  | - LLM client      |     | - WebSocket    |  |   |
|  |  | - Task executor   |     | - Auth/token   |  |   |
|  |  | - Browser agent   |     | - Routing      |  |   |
|  |  +-------------------+     +----------------+  |   |
|  |            |                        |            |
|  |            | internal network      |            |
|  |            +-----------+-----------+            |
|  |                        |                        |
|  +------------------------|------------------------+
|                           |
|                           |
|      +----------------------------------------+   |
|      |          External Services             |   |
|      |----------------------------------------|   |
|      |                                        |   |
|      |  🧠 Ollama (LLM server)                |   |
|      |   http://127.0.0.1:11434              |   |
|      |                                        |   |
|      |  🌐 Internet APIs (Threads / etc.)     |   |
|      |                                        |   |
|      +----------------------------------------+   |
|                                                      |
+------------------------------------------------------+
```
---

# Docker セットアップ
以下を順番に実行すれば、Dockerが使えるようになります。
---

## セットアップ手順（まとめて実行）

```bash
# 1. 基本パッケージ
sudo apt update
sudo apt install -y ca-certificates curl

# 2. GPGキー追加
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 3. リポジトリ追加
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# 4. Dockerインストール
sudo apt update
sudo apt install -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# 5. sudoなし設定
sudo groupadd docker
sudo usermod -aG docker $USER

# 6. グループ反映
newgrp docker

# 7. 動作確認
docker run hello-world
```
---
# 🐳 OpenClaw Docker（GUI動作確認まで一括）
以下をそのまま順番に実行すれば、  
OpenClawコンテナ起動 → GUI確認（xeyes）まで完了します。
```bash
# 1. イメージ取得
docker pull ghcr.io/openclaw/openclaw:main

# 2. コンテナ起動（GUI対応・ホストネットワーク）
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -u root \
  --network host \
  ghcr.io/openclaw/openclaw:main bash

# ===== ここからコンテナ内 =====
# 3. 基本ツールインストール
apt update
apt install -y curl git vim x11-apps fonts-noto-cjk fonts-noto-color-emoji fonts-ipafont

# フォントキャッシュ更新
fc-cache -fv

# 4. GUI動作確認
xeyes
# ===========================================
```


## ollama on host
```
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3.5:4b
reboot
```

# Manual install for openclaw
Official container
```
https://github.com/openclaw/openclaw/pkgs/container/openclaw
```

## on host
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
google-chrome-stable
xhost +local:docker
```


## config openclaw on container 
```
openclaw configure --section model
openclaw configure --section channels
openclaw doctor --fix
openclaw gateway restart
```
## model for remote (openAI Codex)
```
openclaw configure --section model
openclaw models set openai-codex/gpt-5.4
openclaw plugins install acpx
openclaw config set plugins.entries.acpx.enabled true
openclaw gateway restart
openclaw models status

```

## Skills setup
```
npm install -g agent-browser
agent-browser install
agent-browser install --with-deps
```

