# [Host] setup for docker
```
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
## Add the repository to Apt sources:
```
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## for non root setup
Create the docker group.
```
 sudo groupadd docker
```
Add your user to the docker group.
```
 sudo usermod -aG docker $USER
```
Log out and log back in so that your group membership is re-evaluated.

    If you're running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

You can also run the following command to activate the changes to groups:
```
 newgrp docker
```
Verify that you can run docker commands without sudo.
```
 docker run hello-world
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
## model for remote (openAI)
```
openclaw configure --section model
openclaw gateway restart
openclaw models status
```

## Skills setup
```
npm install -g agent-browser
agent-browser install
agent-browser install --with-deps
```

