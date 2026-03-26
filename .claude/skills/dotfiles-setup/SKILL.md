---
name: dotfiles-setup
description: Set up or update dotfiles symlinks and script permissions. Idempotent - safe to run multiple times.
disable-model-invocation: true
---

# Dotfiles Setup

dotfilesリポジトリのシンボリックリンクと実行権限を設定する。冪等性あり（何度実行しても安全）。

リポジトリは `~/dotfiles` に存在することを前提とする。

> **注意: macOSでのみ動作確認済み。** WSL等の他環境では一部のシンボリックリンク先（Ghostty、Karabiner）が不要だったり、パスが異なる場合がある。他環境で実行する場合は各ステップの適否を確認しながら進めること。

## 手順

### 1. リポジトリの場所を確認

`~/dotfiles` が存在しない場合は「リポジトリが見つかりません」と伝えて中断。

### 2. ディレクトリ作成

以下を `mkdir -p` で作成（既存でも無害）：

```
~/.config/nvim
~/.claude/skills
```

### 3. シンボリックリンクの作成・更新

以下をすべて `ln -sf` で設定する。

**ファイル単位でリンク:**

| リンク元 | リンク先 |
|---|---|
| `~/dotfiles/zsh/zshrc` | `~/.zshrc` |
| `~/dotfiles/zsh/zprofile` | `~/.zprofile` |
| `~/dotfiles/git/config` | `~/.gitconfig` |
| `~/dotfiles/git/commit_template` | `~/.commit_template` |
| `~/dotfiles/nvim/init.lua` | `~/.config/nvim/init.lua` |
| `~/dotfiles/claude/settings.json` | `~/.claude/settings.json` |
| `~/dotfiles/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |

**ディレクトリ単位でリンク（循環リンク防止のため、先にターゲットを削除してはいけない）:**

| リンク元 | リンク先 |
|---|---|
| `~/dotfiles/ghostty` | `~/.config/ghostty` |
| `~/dotfiles/karabiner` | `~/.config/karabiner` |
| `~/dotfiles/claude/skills/branch-clean` | `~/.claude/skills/branch-clean` |

> 注意: ディレクトリリンクは、ターゲットが既にディレクトリとして存在する場合に循環リンクになる。
> `ln -sf` の前に `[ -d ~/.config/ghostty ] && [ ! -L ~/.config/ghostty ]` でチェックし、
> 実ディレクトリが存在する場合は「既存ディレクトリあり。手動で確認してください」と警告する。

### 4. 実行権限の付与

```
chmod +x ~/dotfiles/scripts/*.sh
```

### 5. 結果を報告

各リンクについて以下の状態を報告する：
- ✅ 作成済み（既に正しいリンクが存在）
- 🔗 新規作成
- 🔄 更新（リンク先が変わった）
- ⚠️ スキップ（手動確認が必要）

最後に「次のステップ」として以下を案内する（自動実行はしない）：
- Homebrewパッケージ: `brew bundle --file=~/dotfiles/brew/Brewfile`
- GitHub認証: `gh auth login`
- SSH設定: `~/dotfiles/scripts/setup_ssh.sh`
- シェル再読み込み: `source ~/.zshrc`
- Neovimプラグイン同期: `nvim --headless "+Lazy! sync" +qa`
