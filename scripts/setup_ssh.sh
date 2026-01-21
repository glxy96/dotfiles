#!/bin/bash
# SSH config セットアップスクリプト

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/ssh/config.template"
OUTPUT_FILE="$HOME/.ssh/config"

echo "🔑 SSH config セットアップ"
echo ""

# 既存の鍵ファイルを検索
echo "利用可能なSSH鍵:"
echo "---"
find ~/.ssh -maxdepth 1 -type f -name "id_*" ! -name "*.pub" | nl
echo "---"
echo ""

# デフォルト値を設定
DEFAULT_KEY=""
if [[ -f "$HOME/.ssh/id_ed25519_github_glxy96" ]]; then
    DEFAULT_KEY="$HOME/.ssh/id_ed25519_github_glxy96"
elif [[ -f "$HOME/.ssh/id_rsa_github_macmini" ]]; then
    DEFAULT_KEY="$HOME/.ssh/id_rsa_github_macmini"
fi

# ユーザーに鍵のパスを入力させる
if [[ -n "$DEFAULT_KEY" ]]; then
    read -p "GitHub用SSH鍵のパス [デフォルト: $DEFAULT_KEY]: " github_key
    github_key=${github_key:-$DEFAULT_KEY}
else
    read -p "GitHub用SSH鍵のパス (例: ~/.ssh/id_rsa_github_macmini): " github_key
fi

# ~ を展開
github_key="${github_key/#\~/$HOME}"

# 鍵ファイルの存在確認
if [[ ! -f "$github_key" ]]; then
    echo "❌ エラー: 鍵ファイル '$github_key' が見つかりません"
    exit 1
fi

echo ""
echo "📝 設定内容:"
echo "  テンプレート: $TEMPLATE_FILE"
echo "  出力先: $OUTPUT_FILE"
echo "  GitHub鍵: $github_key"
echo ""

# バックアップ作成
if [[ -f "$OUTPUT_FILE" ]] && [[ ! -L "$OUTPUT_FILE" ]]; then
    backup_file="${OUTPUT_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
    echo "⚠️  既存の $OUTPUT_FILE をバックアップします"
    cp "$OUTPUT_FILE" "$backup_file"
    echo "   → $backup_file"
fi

# シンボリックリンクの場合は削除
if [[ -L "$OUTPUT_FILE" ]]; then
    echo "⚠️  既存のシンボリックリンクを削除します"
    rm "$OUTPUT_FILE"
fi

# テンプレートから生成
sed "s|{{GITHUB_SSH_KEY}}|$github_key|g" "$TEMPLATE_FILE" > "$OUTPUT_FILE"
chmod 600 "$OUTPUT_FILE"

echo ""
echo "✅ SSH config のセットアップが完了しました"
echo ""
echo "動作確認:"
echo "  ssh -T git@github.com"
