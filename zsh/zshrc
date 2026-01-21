### Zinit インストール
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### 環境変数・PATH設定
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# ghcup (Haskell)
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# SuperCollider
export PATH="/Applications/SuperCollider.app/Contents/MacOS:$PATH"

### Zsh基本設定
# ディレクトリ移動
setopt auto_cd

# ヒストリー設定
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# コマンドミス修正
setopt correct

# 補完

if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit && compinit

# 小文字でも大文字ディレクトリ、ファイルを補完できるようにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

### プロンプト設定
autoload -U colors && colors
source ~/.zsh/git-prompt.sh
setopt PROMPT_SUBST

PROMPT='%F{yellow}[%*]%f %F{green}%n%f@%m %F{cyan}%~%f'
PROMPT+='%{$fg[red]%}$(__git_ps1 "(%s)")%{$reset_color%} > '

### エイリアス
alias ls="gls --color=auto"
alias wol='wakeonlan'

### Zinitプラグイン

# 補完・サジェスト
zinit load zsh-users/zsh-autosuggestions
zinit load zsh-users/zsh-completions

# ヒストリー検索
zinit ice wait'!0'; zinit load zdharma/history-search-multi-word
zinit ice wait'!0'; zinit load zsh-users/zsh-history-substring-search

# nodeバージョン管理(fnm)
eval "$(fnm env --use-on-cd)"

# シンタックスハイライト（最後に配置）
zinit ice wait'!0'; zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern cursor root)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
