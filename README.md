# dotfiles

glxy96の開発環境設定ファイル

## 概要

このリポジトリには以下の設定が含まれています：

- **Homebrew**: パッケージ管理（Brewfile, Brewfile.music）
- **Zsh**: シェル環境設定（.zshrc, .zprofile, .zsh/）
- **Git**: バージョン管理設定（.gitconfig, .commit_template）
- **Neovim**: エディタ設定（init.lua）
- **Ghostty**: ターミナルエミュレータ設定（config）
- **Karabiner-Elements**: キーボードカスタマイズ設定（karabiner/）
- **SSH**: 接続設定（config - マシン固有）

## セットアップ手順

### 前提条件

- **Homebrew**（必須）
- **Git**
- **Zsh**

その他のツールはBrewfileで一括インストール可能です。

### インストール
```bash
# リポジトリをクローン
git clone git@github.com:glxy96/dotfiles.git ~/dotfiles
cd ~/dotfiles

# パッケージとアプリケーションをインストール
brew bundle

# GitHub認証
gh auth login

# 既存設定をバックアップ（任意）
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
[ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
[ -f ~/.zprofile ] && cp ~/.zprofile "$backup_dir/"
[ -d ~/.zsh ] && cp -r ~/.zsh "$backup_dir/"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$backup_dir/"
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua "$backup_dir/"
[ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$backup_dir/"
[ -d ~/.config/karabiner ] && cp -r ~/.config/karabiner "$backup_dir/"

# シンボリックリンク作成
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zsh ~/.zsh
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.commit_template ~/.commit_template
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/karabiner ~/.config/karabiner

# SSH config セットアップ
./setup_ssh.sh

# 設定を反映
source ~/.zshrc
nvim --headless "+Lazy! sync" +qa
```

## Brewfile について

`Brewfile` は開発環境に必要なパッケージとアプリケーションを定義したファイルです。

### 使い方

```bash
# パッケージを一括インストール
cd ~/dotfiles
brew bundle

# 音楽制作環境も追加でインストール
brew bundle --file=Brewfile.music

# Brewfileを更新
brew bundle dump --force
```

### 含まれるパッケージ

- **開発ツール**: Git, Neovim, ripgrep, fd, fzf など
- **言語環境**: pyenv (Python), fnm (Node.js)
- **インフラツール**: AWS CLI, Docker, Terraform
- **GUIアプリ**: Ghostty, Chrome, Obsidian, Raycast, Karabiner-Elements など
- **Mac App Store**: Magnet, LINE など

音楽制作環境は `Brewfile.music` を参照してください。

## SSH config について

`ssh/config` はマシン固有のSSH鍵パスを含むため、Git管理から除外しています。

### セットアップ方法

#### 1. GitHub CLIで認証（初回のみ）

```bash
gh auth login
```

選択項目：
- **Where do you use GitHub?** → `GitHub.com`
- **What is your preferred protocol?** → `SSH`
- **Upload your SSH public key?** → 既存の鍵を選択、または`Yes`で新規作成
- **Title for your SSH key** → マシン名など（例: `macbook-air`）
- **How would you like to authenticate?** → `Login with a web browser`

#### 2. SSH config を生成

```bash
./setup_ssh.sh
```

利用可能なSSH鍵から選択し、`~/.ssh/config`を生成します。

#### 3. 動作確認

```bash
ssh -T git@github.com
```

### 手動でセットアップする場合
```bash
cp ssh/config.template ~/.ssh/config
vim ~/.ssh/config  # {{GITHUB_SSH_KEY}} を実際の鍵パスに置換
chmod 600 ~/.ssh/config
ssh -T git@github.com
```

### 各マシンの鍵情報（参考）

- **MacBook**: `~/.ssh/id_ed25519_github_glxy96`
- **Mac mini**: `~/.ssh/id_rsa_github_macmini`

## 主な機能

- **Homebrew**: 開発ツール、言語環境、GUIアプリの一括管理
- **Zsh**: プラグイン管理、補完、Git統合
- **Neovim**: Markdown編集、ファイル検索、PKM機能
- **Git**: コミットテンプレート、エディタ連携
- **Ghostty**: テーマ設定、フォント設定
- **Karabiner-Elements**: Command/Optionキーで日本語入力切り替え、RDP用キーマッピング

### PKM機能（Obsidian連携）

ノート管理機能を使用する場合は、以下のディレクトリを作成してください：
```bash
mkdir -p ~/pkm/{daily,weekly,inbox/temporary,templates}
```

## トラブルシューティング

### SSH接続エラー
```bash
ssh -T git@github.com
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
git add .
git commit -m "📝 Update configuration"
git push -u origin <branch-name>
```
