# ----------------------------
# 1. Oh-My-Zsh
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# ----------------------------
# 2. PATH (early, so tools below can be found)
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$(npm prefix -g)/bin:$PATH"

# ----------------------------
# 3. Let WSL mirrored networking + autoProxy manage proxy env vars.
# Keep a separate quick IP alias without shadowing /usr/local/bin/checkproxy.
unset ALL_PROXY all_proxy
export http_proxy="${HTTP_PROXY:-${http_proxy:-}}"
export https_proxy="${HTTPS_PROXY:-${https_proxy:-}}"

# ----------------------------
# 4. Zsh behavior
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups hist_ignore_space hist_reduce_blanks
setopt share_history inc_append_history extended_history
setopt auto_cd correct interactive_comments
setopt no_beep nonomatch

# ----------------------------
# 5. Completion
autoload -Uz compinit
if [[ -f ~/.zcompdump ]]; then
  compinit -C
else
  compinit
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ----------------------------
# 6. Prompt (starship)
eval "$(starship init zsh)"

# ----------------------------
# 7. Aliases
alias ls='eza --color=auto --icons'
alias ll='eza -alF --icons --git'
alias la='eza -a --icons'
alias l='eza -F --icons'
alias tree='eza --tree --icons'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --decorate -n 20'
alias cat='batcat --paging=never'
alias bat='batcat'
alias fd='fdfind'

# ----------------------------
# 8. Environment
export EDITOR=nano
export LANG=en_US.UTF-8

# ----------------------------
# 9. Tool integrations
eval "$(zoxide init zsh)"                          # z <dir> to jump
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf keybindings (Ctrl+R history, Ctrl+T file picker, Alt+C cd)
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
