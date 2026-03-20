#!/usr/bin/env bash
set -Eeuo pipefail

COMPOSE_FILE="docker-compose.yml"
SERVICE_NAME="openclaw"

print_step() {
  echo
  echo "=================================================="
  echo "$1"
  echo "=================================================="
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[ERROR] '$1' が見つかりません。先にインストールしてください。"
    exit 1
  fi
}

print_step "[0/5] 前提コマンド確認"
require_cmd docker
require_cmd xhost

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "[ERROR] $COMPOSE_FILE が見つかりません。"
  exit 1
fi

print_step "[1/5] DISPLAY 確認"
if [[ -z "${DISPLAY:-}" ]]; then
  echo "[ERROR] DISPLAY が設定されていません。GUI を使うには X11 セッション上で実行してください。"
  exit 1
fi
echo "[OK] DISPLAY=${DISPLAY}"

print_step "[2/5] xhost 設定"
if xhost +local:docker >/dev/null 2>&1; then
  echo "[OK] xhost +local:docker を設定しました"
else
  echo "[WARN] xhost +local:docker に失敗しました。環境によっては 'xhost +local:' を試してください。"
fi

print_step "[3/5] Docker image をビルド"
docker compose -f "$COMPOSE_FILE" build

print_step "[4/5] コンテナ起動"
docker compose -f "$COMPOSE_FILE" up -d

print_step "[5/5] コンテナへ入る"
echo "[INFO] 終了後に X11 許可を戻したい場合はホストで次を実行:"
echo "       xhost -local:docker"
echo
docker compose -f "$COMPOSE_FILE" exec "$SERVICE_NAME" bash
