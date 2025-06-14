# dotfiles

glxy96の開発環境設定ファイル

## 概要

このリポジトリには以下の設定が含まれています：

- **Zsh**: シェル環境設定（.zshrc, .zprofile）
- **Git**: バージョン管理設定（.gitconfig, .commit_template）
- **Neovim**: エディタ設定（init.lua）
- **SSH**: 接続設定（config）

## セットアップ手順

### 前提条件

以下がインストールされていることを確認してください：

- Git
- Zsh
- Neovim
- 必要に応じて：pyenv、Node.js、AWS CLI

### 1. dotfilesのクローン

```bash
git clone git@github.com:glxy96/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. 既存設定のバックアップ

```bash
# 既存設定をバックアップ
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# バックアップ対象
[ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
[ -f ~/.zprofile ] && cp ~/.zprofile "$backup_dir/"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$backup_dir/"
[ -f ~/.commit_template ] && cp ~/.commit_template "$backup_dir/"
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua "$backup_dir/"
[ -f ~/.ssh/config ] && cp ~/.ssh/config "$backup_dir/"

echo "Backup created at: $backup_dir"
```

### 3. シンボリックリンクの作成

```bash
# Zsh設定
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zprofile ~/.zprofile

# Git設定
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.commit_template ~/.commit_template

# Neovim設定
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua

# SSH設定
ln -sf ~/dotfiles/ssh/config ~/.ssh/config
```

### 4. 設定の反映

```bash
# Zsh設定を再読み込み
source ~/.zshrc

# Neovimプラグインのインストール
nvim --headless "+Lazy! sync" +qa
```

## 主な機能

### Zsh
- **Zinit**: プラグイン管理
- **補完・サジェスト**: zsh-autosuggestions, zsh-completions
- **シンタックスハイライト**: zsh-syntax-highlighting
- **Git統合**: プロンプトでブランチ表示

### Git
- **コミットテンプレート**: 絵文字付きコミット規約
- **エディタ設定**: Neovim連携
- **カラー出力**: 見やすい表示

### Neovim
- **Markdown支援**: プレビュー、Lint、箇条書き支援
- **検索機能**: Telescopeによるファイル・文字列検索
- **補完**: nvim-cmp
- **PKM機能**: Obsidian連携（※要PKMリポジトリ）

### キーマップ

| キー | 機能 | 備考 |
|------|------|------|
| `<leader>ff` | ファイル検索 | |
| `<leader>fg` | 文字列検索 | |
| `<leader>jd` | 今日のデイリーノート | ※PKMリポジトリが必要 |
| `<leader>jw` | ウィークリーノート | ※PKMリポジトリが必要 |

### PKM機能について

デイリーノート・ウィークリーノート機能は、別途PKMリポジトリ（`~/asobiba/garden-glxy96`）の存在を前提としています。PKMシステムを使用しない場合、これらの機能は無効になります。

## プラットフォーム別注意点

### macOS
- Homebrewのパス設定が含まれています
- SSH鍵のパスはmacOS環境を想定

### Linux/WSL
- Homebrew関連の設定は適宜修正してください
- パスの差異にご注意ください

## トラブルシューティング

### シンボリックリンクの確認
```bash
ls -la ~/ | grep "\->"
ls -la ~/.config/nvim/ | grep "\->"
```

### 設定の復元
```bash
# バックアップから復元
cp ~/.dotfiles_backup_YYYYMMDD_HHMMSS/.zshrc ~/
# その他のファイルも同様
```

### Neovimプラグインエラー
```bash
# プラグインを再インストール
nvim --headless "+Lazy! clean" +qa
nvim --headless "+Lazy! sync" +qa
```

## 関連ツール

- [Obsidian](https://obsidian.md/): PKMシステム
- [Zinit](https://github.com/zdharma-continuum/zinit): Zshプラグイン管理
- [lazy.nvim](https://github.com/folke/lazy.nvim): Neovimプラグイン管理

## 更新履歴

設定を変更した際は、このリポジトリにpushして複数マシン間で同期してください。

```bash
cd ~/dotfiles
git add .
git commit -m "🐛 Fix example configuration"
git push
```
