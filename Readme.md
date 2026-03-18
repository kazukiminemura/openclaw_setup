# Host setup

sudo apt install git

```
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

# Add the repository to Apt sources:
```
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## ollama
```
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3.5:4b
reboot
```

# Client setup
```
git clone https://github.com/openclaw/openclaw.git
cd openclaw
```

## create .env
```
# =========================
# OpenClaw 基本（必須）
# =========================
OPENCLAW_GATEWAY_TOKEN=CHANGE_ME_LONG_RANDOM_TOKEN
TZ=Asia/Tokyo

# =========================
# ローカルLLM（Ollama: OpenAI互換）
# Dockerコンテナからホストへは host.docker.internal を使う
# =========================
OPENAI_BASE_URL=http://host.docker.internal:11434/v1
OPENAI_API_KEY=dummy-ignored-by-ollama

# モデル名（Ollama側に存在するもの）
OPENAI_MODEL=qwen3.5:4b

# =========================
# チャネル：Telegram
# =========================
TELEGRAM_BOT_TOKEN=CHANGE_ME

# =========================
# チャネル：Discord
# =========================
DISCORD_BOT_TOKEN=CHANGE_ME
DISCORD_GUILD_ID=CHANGE_ME   # 任意（分かるなら）
DISCORD_CHANNEL_ID=CHANGE_ME # 任意（分かるなら）

# =========================
# チャネル：Slack（Socket Mode推奨）
# =========================
SLACK_BOT_TOKEN=xoxb-CHANGE_ME
SLACK_APP_TOKEN=xapp-CHANGE_ME

# =========================
# チャネル：LINE（Webhookが必要）
# =========================
LINE_CHANNEL_ACCESS_TOKEN=CHANGE_ME
LINE_CHANNEL_SECRET=CHANGE_ME
# Webhookを受ける公開URL（後でCloudflare/Tailscaleなどで作る）
LINE_WEBHOOK_BASE_URL=https://CHANGE_ME.example.com
```

sudo ./docker-setup.sh
```

## トークン生成（最低限）
```
python3 - <<'PY'
import secrets
print(secrets.token_urlsafe(48))
PY
```

出た文字列を .env の OPENCLAW_GATEWAY_TOKEN に貼る。


## docker-compose.yml（ローカル限定＆安全寄り）
docker-compose.yml を作成：
```
version: "3.9"

services:
  openclaw:
    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw
    env_file:
      - .env

    # ✅ 重要：外部に晒さない（localhost限定）
    ports:
      - "127.0.0.1:3000:3000"

    # ✅ 重要：最低限だけマウント
    volumes:
      - ./workspace:/workspace
      - ./config:/config

    # ✅ Linux対策：host.docker.internal を生やす（Mac/Winでも害はない）
    extra_hosts:
      - "host.docker.internal:host-gateway"

    restart: unless-stopped
```
## ポイント
    127.0.0.1:3000:3000 で ローカルPCからしかアクセスできない
    env_file: .env で秘密情報は環境変数一元化（gitに載せない）
    Linuxでも host.docker.internal を使えるよう extra_hosts を入れる
