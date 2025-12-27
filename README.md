# dotfiles

glxy96の開発環境設定ファイル

## 概要

このリポジトリには以下の設定が含まれています：

- **Zsh**: シェル環境設定（.zshrc, .zprofile, .zsh/）
- **Git**: バージョン管理設定（.gitconfig, .commit_template）
- **Neovim**: エディタ設定（init.lua）
- **Ghostty**: ターミナルエミュレータ設定（config）
- **SSH**: 接続設定（config）

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
ln -sf ~/dotfiles/ssh/config ~/.ssh/config

# 4. 設定を反映
source ~/.zshrc
nvim --headless "+Lazy! sync" +qa
```

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
git add .
git commit -m "📝 Update configuration"
git push
```
