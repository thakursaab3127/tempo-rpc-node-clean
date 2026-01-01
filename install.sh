#!/bin/bash
set -e

echo "🚀 Tempo RPC Node – Installation"

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

echo "📦 Installing system dependencies..."
apt update
apt install -y curl wget git lz4 tar

# Install Tempo binary
if ! command -v tempo >/dev/null 2>&1; then
  echo "⬇️ Downloading Tempo binary..."
  curl -L https://github.com/tempoxyz/tempo/releases/latest/download/tempo-linux-amd64 -o tempo

  echo "🔍 Verifying binary..."
  FILE_SIZE=$(stat -c%s tempo)
  if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo "❌ Invalid Tempo binary download"
    exit 1
  fi

  chmod +x tempo
  mv tempo /usr/local/bin/tempo
fi

echo "✅ Tempo installed:"
tempo --version || true

echo "📥 Downloading snapshot (optional but recommended)..."
tempo download || true

echo "🎉 Installation completed successfully"

