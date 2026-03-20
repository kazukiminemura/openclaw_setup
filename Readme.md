
# 🐳 Openclaw　セットアップ（Ubuntu）
OSS openclawをdocker使ってのセットアップ方法
---

# 🐳 Docker セットアップ
以下を順番に実行すれば、Dockerが使えるようになります。
---

## 🔧 セットアップ手順（まとめて実行）

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

## ✅ 完了後にできること

- sudoなしで `docker` が使える
- `docker compose` が使える
- AI環境（OpenClaw / Ollamaなど）構築可能

---

## ⚠️ うまくいかない場合

```bash
groups
```

👉 `docker` が含まれていなければ再ログイン




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

