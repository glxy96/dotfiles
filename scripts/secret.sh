#!/bin/bash
# secrets/secrets.sops.yaml から指定した1キーだけを復号して標準出力する
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRETS_FILE="$SCRIPT_DIR/../secrets/secrets.sops.yaml"

# OSごとのデフォルト鍵パスの違いを避けるため明示的に指定する
export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"

if [ -z "$1" ]; then
  echo "❌ Usage: secret.sh <KEY_NAME>" >&2
  exit 1
fi
KEY_NAME="$1"

if ! command -v sops &>/dev/null; then
  echo "❌ sops がインストールされていません (brew install sops age)" >&2
  exit 1
fi

VALUE=$(sops decrypt --extract "[\"$KEY_NAME\"]" "$SECRETS_FILE" 2>/dev/null) || {
  echo "❌ Failed to read secret: $KEY_NAME" >&2
  exit 1
}

printf '%s' "$VALUE"
