# dotfiles

glxy96の開発環境設定ファイル

## 概要

このリポジトリには以下の設定が含まれています：

- **Homebrew**: パッケージ管理（brew/）
- **Zsh**: シェル環境設定（zsh/）
- **Git**: バージョン管理設定（git/）
- **Neovim**: エディタ設定（nvim/）
- **Ghostty**: ターミナルエミュレータ設定（ghostty/）
- **Karabiner-Elements**: キーボードカスタマイズ設定（karabiner/）
- **SSH**: 接続設定（ssh/）
- **Claude Code**: AIアシスタント設定（claude/）

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
brew bundle --file=brew/Brewfile

# GitHub認証
gh auth login

# 既存設定をバックアップ（任意）
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
[ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
[ -f ~/.zprofile ] && cp ~/.zprofile "$backup_dir/"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$backup_dir/"
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua "$backup_dir/"
[ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$backup_dir/"
[ -d ~/.config/karabiner ] && cp -r ~/.config/karabiner "$backup_dir/"
[ -f ~/.claude/settings.json ] && cp ~/.claude/settings.json "$backup_dir/"
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md "$backup_dir/"

# シンボリックリンク作成
ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/zprofile ~/.zprofile
ln -sf ~/dotfiles/git/config ~/.gitconfig
ln -sf ~/dotfiles/git/commit_template ~/.commit_template
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/karabiner ~/.config/karabiner
mkdir -p ~/.claude
ln -sf ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -sf ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md

# スクリプトに実行権限を付与
chmod +x scripts/*.sh

# SSH config セットアップ
./scripts/setup_ssh.sh

# 設定を反映
source ~/.zshrc
nvim --headless "+Lazy! sync" +qa
```

## Brewfile について

`brew/Brewfile` は開発環境に必要なパッケージとアプリケーションを定義したファイルです。

### 使い方

```bash
cd ~/dotfiles

# パッケージを一括インストール
brew bundle --file=brew/Brewfile

# 音楽制作環境も追加でインストール
brew bundle --file=brew/Brewfile.music
```

### 含まれるパッケージ

- **開発ツール**: Git, Neovim, ripgrep, fd, fzf など
- **言語環境**: pyenv (Python), fnm (Node.js)
- **インフラツール**: AWS CLI, Docker, Terraform
- **GUIアプリ**: Ghostty, Chrome, Obsidian, Raycast, Karabiner-Elements など
- **Mac App Store**: Magnet, LINE など

音楽制作環境は `brew/Brewfile.music` を参照してください。

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

#### 2. SSH config を生成（GitHub用）

```bash
./scripts/setup_ssh.sh
```

#### 3. 追加ホストの設定（任意）

自宅サーバー等への接続が必要な場合：

```bash
# 秘密鍵を別マシンからコピー（AirDrop等）
# 必要なホスト設定を追記
cat ssh/config.d/home.conf >> ~/.ssh/config
```

`ssh/config.d/`には以下のファイルがあります：
- `home.conf` - 自宅ネットワーク（raspi, ubuntu等）

#### 4. 動作確認

```bash
ssh -T git@github.com
ssh raspi  # 追加ホストを設定した場合
```

## 主な機能

- **Homebrew**: 開発ツール、言語環境、GUIアプリの一括管理
- **Zsh**: プラグイン管理、補完、Git統合
- **Neovim**: Markdown編集、ファイル検索、PKM機能
- **Git**: コミットテンプレート、エディタ連携
- **Ghostty**: テーマ設定、フォント設定
- **Karabiner-Elements**: Command/Optionキーで日本語入力切り替え、RDP用キーマッピング
- **Claude Code**: デフォルトモデル、Gitワークフロー、コーディング指針

### PKM機能（Obsidian連携）

ノート管理機能を使用する場合は、以下のディレクトリを作成してください：
```bash
mkdir -p ~/pkm/{daily,weekly,inbox/temporary,templates}
```

## トラブルシューティング

### SSH接続エラー
```bash
ssh -T git@github.com
./scripts/setup_ssh.sh
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
