# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for macOS development environment synchronization across multiple machines. Contains shell configuration, editor settings, terminal emulator config, and Git/SSH settings.

## Repository Structure

```
dotfiles/
├── .zshrc              # Zsh configuration (plugins, prompt, aliases)
├── .zprofile           # PATH settings (Homebrew, Java, pyenv, etc.)
├── .zsh/               # Zsh-related scripts
│   └── git-prompt.sh   # Git prompt display script (from Git official repo)
├── .gitconfig          # Git configuration
├── .commit_template    # Git commit template with emoji prefixes
├── nvim/
│   └── init.lua        # Neovim configuration (lazy.nvim, Telescope, Treesitter)
├── ghostty/
│   └── config          # Ghostty terminal emulator settings
└── ssh/
    └── config          # SSH connection settings
```

## Symlink Strategy

This repository uses a specific symlink strategy to avoid circular link issues:

**Link entire directories:**
- `.zsh/` → `~/.zsh` (contains git-prompt.sh required by .zshrc)
- `ghostty/` → `~/.config/ghostty` (prevents circular link if directory exists first)

**Link specific files only:**
- `nvim/init.lua` → `~/.config/nvim/init.lua` (other nvim files may be added in future)
- `ssh/config` → `~/.ssh/config` (other files like private keys exist in ~/.ssh/)

**Link root-level files:**
- `.zshrc`, `.zprofile`, `.gitconfig`, `.commit_template` → home directory

## Git Workflow

**IMPORTANT:** Never commit directly to main branch. Always create a feature branch first:

```bash
git checkout -b <branch-name>
# Make changes and commit
git push -u origin <branch-name>
# User will create PR and merge on GitHub
```

After PR is merged:
```bash
git checkout main
git pull
git branch -d <branch-name>
```

### Commit Message Format

This repository uses emoji prefixes in commit messages (see .commit_template). Common ones:

- 📝 `:memo:` - Documentation/comments
- ✨ `:sparkles:` - Feature addition (partial)
- 👍 `:+1:` - Feature improvement
- 🐛 `:bug:` - Bug fix
- ♻️ `:recycle:` - Refactoring
- 👕 `:shirt:` - Lint/code style fixes

## Cross-Machine Sync Considerations

When modifying configuration files, consider:

1. **External dependencies not in repo:**
   - HackGen Console NF font (used by Ghostty)
   - Zinit (auto-installed on first .zshrc source)
   - Language version managers (pyenv, fnm, ghcup)

2. **Machine-specific settings:**
   - `ssh/config`: Contains `Include /Users/ginga/.colima/ssh_config` (may not exist on all machines)
   - `ssh/config`: IdentityFile paths refer to private keys not in repo
   - `.gitconfig`: Username/email may need overriding per machine

3. **Files required for setup:**
   - `.zsh/git-prompt.sh` must be in repo (referenced by .zshrc line 49)
   - Without this file, zsh initialization will fail on new machines

## Key Configuration Details

### Zsh Setup
- Uses Zinit for plugin management (auto-installs to `~/.local/share/zinit/`)
- Git prompt integration via `.zsh/git-prompt.sh`
- PATH configuration in `.zprofile` for Homebrew, Java, pyenv, SuperCollider

### Neovim Setup
- Uses lazy.nvim package manager (auto-bootstraps on first run)
- Configured for Markdown editing and PKM (Personal Knowledge Management)
- Requires `nvim --headless "+Lazy! sync" +qa` after initial setup

### PKM/Obsidian Integration
Neovim is configured for note-taking with expected directory structure:
```bash
~/pkm/{daily,weekly,inbox/temporary,templates}
```

## Testing Changes

When modifying configuration files:

1. **Shell configs (.zshrc, .zprofile):**
   ```bash
   source ~/.zshrc  # Test if it loads without errors
   ```

2. **Neovim config (nvim/init.lua):**
   ```bash
   nvim --headless "+Lazy! sync" +qa  # Sync plugins
   nvim  # Open and check for errors
   ```

3. **SSH config:**
   ```bash
   ssh -T git@github.com  # Test GitHub connection
   ```

## Common Issues

1. **Circular symlinks with ghostty:**
   - Never `mkdir ~/.config/ghostty` before symlinking
   - Link the entire directory: `ln -sf ~/dotfiles/ghostty ~/.config/ghostty`

2. **Missing git-prompt.sh:**
   - Causes zsh initialization failure
   - Must be present in `.zsh/` directory in repo

3. **Font not rendering correctly:**
   - Install HackGen Console NF: `brew install --cask font-hackgen-nerd`
