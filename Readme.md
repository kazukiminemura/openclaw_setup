
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
  -e TZ=Asia/Tokyo \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /home/threads-001/threads:/run/threads:ro \
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
---

# 🤖 OpenClaw（OpenAI Codex / GPT-5.4 リモートモデル設定）
以下を順番に実行すれば、  
OpenClawコンテナ内で **Codex（GPT-5.4）をリモートモデルとして設定**できます。

```bash
# ===== OpenClaw リモートモデル設定（Codex） =====

# 1. モデル設定画面へ
openclaw configure --section model

# 2. 使用モデルを設定（OpenAI Codex）
openclaw models set openai-codex/gpt-5.4

# 3. OpenAI接続用プラグインをインストール
openclaw plugins install acpx

# 4. プラグインを有効化
openclaw config set plugins.entries.acpx.enabled true
openclaw config set plugins.allow '["acpx"]'

# 5. gateway再起動（設定反映）
openclaw gateway restart

# 6. 状態確認
openclaw models status

# ==============================================
```

## 🧠 OpenClaw + Ollama（ローカルモデル）設定
以下の手順で、ホスト上のOllamaをOpenClawコンテナから利用できます。
```bash
# ===== Ollama セットアップ（ホスト） =====

# 1. Ollamaインストール
curl -fsSL https://ollama.com/install.sh | sh

# 2. モデル取得
ollama pull qwen3.5:4b

# 3. 再起動（推奨）
reboot

# ===== OpenClaw 側設定（コンテナ内） =====

# 1. モデル設定画面
openclaw configure --section model

# （ここで Ollama / qwen3.5:4b を選択）
# ========================================
```
---

# 🚀 OpenClaw 起動方法（Gateway）
OpenClawを起動するには、gateway（通信部分）を立ち上げます。
```bash
# ① Gateway起動（必須）
openclaw gateway &

# ② 初期設定（モデル・チャネル）
openclaw configure --section channels
openclaw pairing approve discord xxxxx

# ③ 自動修復
openclaw doctor --fix

# ④ 再起動（設定反映）
openclaw gateway restart
```
---

## other setup
```
apt install python3.11-venv -y
```

# Manual install for openclaw

## on host
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
google-chrome-stable
xhost +local:docker
```



## Skills setup
```
npm install -g agent-browser
agent-browser install
agent-browser install --with-deps
```

