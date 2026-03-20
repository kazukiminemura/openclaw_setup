# 🐳 Docker セットアップ手順（Ubuntu）

---

## 1️⃣ 事前準備

Dockerをインストールする前に必要なパッケージを入れます。

```bash
sudo apt update
sudo apt install -y ca-certificates curl
```

---

## 2️⃣ Docker公式GPGキーの追加

```bash
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc
```

---

## 3️⃣ Dockerリポジトリの追加

Dockerのパッケージ取得先を登録します。

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

---

## 4️⃣ Dockerのインストール

```bash
sudo apt update

sudo apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

---

## 5️⃣ sudoなしでDockerを使う設定

### 🔹 dockerグループ作成

```bash
sudo groupadd docker
```

※ 既に存在する場合は無視されます

---

### 🔹 ユーザーをdockerグループに追加

```bash
sudo usermod -aG docker $USER
```

---

### 🔹 グループ設定を反映

```bash
newgrp docker
```

または一度ログアウト → 再ログイン

---

## 6️⃣ 動作確認

```bash
docker run hello-world
```

---

## ✅ 補足

### Dockerが動いているか確認

```bash
docker ps
```

---

### Dockerサービス確認

```bash
systemctl status docker
```

---

### ❌ トラブルシュート（permission denied）

```bash
groups
```

👉 `docker` が含まれていない場合は再ログイン

---

## 🚀 完了

これで以下が可能になります：

- `docker run` をsudoなしで実行
- `docker compose` の利用
- AI環境（OpenClaw / Ollamaなど）の構築




# Openclaw docker image list
```
https://github.com/openclaw/openclaw/pkgs/container/openclaw
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

```
docker pull ghcr.io/openclaw/openclaw:main
docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -u root --network host ghcr.io/openclaw/openclaw:main bash
apt update && apt install curl git vim x11-apps -y
apt install fonts-noto-cjk fonts-noto-color-emoji fonts-ipafont fc-cache -y
xeyes
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

