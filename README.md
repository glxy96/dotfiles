# dotfiles

glxy96の開発環境設定ファイル

## 概要

このリポジトリには以下の設定が含まれています：

- **Zsh**: シェル環境設定（.zshrc, .zprofile, .zsh/）
- **Git**: バージョン管理設定（.gitconfig, .commit_template）
- **Neovim**: エディタ設定（init.lua）
- **Ghostty**: ターミナルエミュレータ設定（config）
- **SSH**: 接続設定（config - マシン固有）

## セットアップ手順

### 前提条件

- Git
- Zsh
- Neovim (>= 0.9.0)
- ripgrep
- Ghostty（任意）
- HackGen Console NF フォント（Ghostty使用時に推奨）
  - [HackGen](https://github.com/yuru7/HackGen/releases)からダウンロード＆インストール
  - または Homebrew: `brew install --cask font-hackgen-nerd`

### インストール
```bash
# 1. リポジトリをクローン
git clone git@github.com:glxy96/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. 既存設定をバックアップ（任意）
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
[ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
[ -f ~/.zprofile ] && cp ~/.zprofile "$backup_dir/"
[ -d ~/.zsh ] && cp -r ~/.zsh "$backup_dir/"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$backup_dir/"
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua "$backup_dir/"
[ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$backup_dir/"

# 3. シンボリックリンク作成
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zsh ~/.zsh
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.commit_template ~/.commit_template
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/ghostty ~/.config/ghostty

# 4. SSH config セットアップ（対話式）
./setup_ssh.sh

# 5. 設定を反映
source ~/.zshrc
nvim --headless "+Lazy! sync" +qa
```

## SSH config について

`ssh/config` はマシン固有のSSH鍵パスを含むため、Git管理から除外しています。

### セットアップ方法

対話式スクリプトで簡単にセットアップできます：
```bash
./setup_ssh.sh
```

スクリプトは以下を実行します：
1. 利用可能なSSH鍵を表示
2. GitHub用の鍵を選択（デフォルト値あり）
3. `ssh/config.template` から `~/.ssh/config` を生成
4. 適切な権限（600）を設定

### 手動でセットアップする場合
```bash
# テンプレートから生成
cp ssh/config.template ~/.ssh/config

# GitHub鍵のパスを書き換え
# {{GITHUB_SSH_KEY}} を実際の鍵パス（例: ~/.ssh/id_rsa_github_macmini）に置換
vim ~/.ssh/config

# 権限設定
chmod 600 ~/.ssh/config

# 動作確認
ssh -T git@github.com
```

### 各マシンの鍵情報（参考）

- **MacBook**: `~/.ssh/id_ed25519_github_glxy96`
- **Mac mini**: `~/.ssh/id_rsa_github_macmini`

## 主な機能

- **Zsh**: プラグイン管理、補完、Git統合
- **Neovim**: Markdown編集、ファイル検索、PKM機能
- **Git**: コミットテンプレート、エディタ連携
- **Ghostty**: テーマ設定、フォント設定

### PKM機能（Obsidian連携）

ノート管理機能を使用する場合は、以下のディレクトリを作成してください：
```bash
mkdir -p ~/pkm/{daily,weekly,inbox/temporary,templates}
```

## トラブルシューティング

### SSH接続エラー
```bash
# GitHub接続テスト
ssh -T git@github.com

# エラーが出る場合はSSH configを再セットアップ
./setup_ssh.sh
```

### プラグインエラー
```bash
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! sync" +qa
```

### 設定の復元
```bash
cp ~/.dotfiles_backup_YYYYMMDD_HHMMSS/.zshrc ~/
```

## 更新
```bash
cd ~/dotfiles
git checkout -b <branch-name>
# 変更を加える
git add .
git commit -m "📝 Update configuration"
git push -u origin <branch-name>
# GitHub上でPRを作成してマージ
```
