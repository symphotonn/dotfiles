# ----------------------------
# 1. PATH (early, so tools below can be found)
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
command -v npm &>/dev/null && export PATH="$(npm prefix -g)/bin:$PATH"

# macOS Homebrew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ----------------------------
# 2. Proxy (WSL + Clash mirrored networking)
if grep -qi microsoft /proc/version 2>/dev/null; then
  unset ALL_PROXY all_proxy
  export http_proxy="${HTTP_PROXY:-${http_proxy:-}}"
  export https_proxy="${HTTPS_PROXY:-${https_proxy:-}}"
fi

# ----------------------------
# 3. Zsh behavior
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups hist_ignore_space hist_reduce_blanks
setopt share_history inc_append_history extended_history
setopt auto_cd correct interactive_comments
setopt no_beep nonomatch

# ----------------------------
# 4. Completion
autoload -Uz compinit
if [[ -f ~/.zcompdump ]]; then
  compinit -C
else
  compinit
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ----------------------------
# 5. Prompt (starship)
eval "$(starship init zsh)"

# ----------------------------
# 6. Aliases
# ls → eza
if command -v eza &>/dev/null; then
  alias ls='eza --color=auto --icons'
  alias ll='eza -alF --icons --git'
  alias la='eza -a --icons'
  alias l='eza -F --icons'
  alias tree='eza --tree --icons'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --decorate -n 20'

# bat (named batcat on Debian/Ubuntu, bat elsewhere)
if command -v batcat &>/dev/null; then
  alias cat='batcat --paging=never'
  alias bat='batcat'
elif command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# fd (named fdfind on Debian/Ubuntu, fd elsewhere)
if command -v fdfind &>/dev/null; then
  alias fd='fdfind'
  FD_CMD="fdfind"
else
  FD_CMD="fd"
fi

# ----------------------------
# 7. Environment
export EDITOR="${EDITOR:-nano}"
export LANG=en_US.UTF-8

# ----------------------------
# 8. Tool integrations
# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# zsh plugins (cross-platform paths)
DOTFILES_DIR="${${(%):-%x}:A:h}"
[[ -f "$DOTFILES_DIR/zsh-compat.zsh" ]] && source "$DOTFILES_DIR/zsh-compat.zsh"

# fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND="$FD_CMD --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FD_CMD --type d --hidden --follow --exclude .git"

# ----------------------------
# 9. Local overrides (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
