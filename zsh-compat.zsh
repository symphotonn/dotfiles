# Auto-detect zsh plugin paths per platform
for dir in \
  /usr/share/zsh-autosuggestions \
  /usr/share/zsh/plugins/zsh-autosuggestions \
  /opt/homebrew/share/zsh-autosuggestions \
  /usr/local/share/zsh-autosuggestions; do
  [[ -f "$dir/zsh-autosuggestions.zsh" ]] && source "$dir/zsh-autosuggestions.zsh" && break
done

for dir in \
  /usr/share/zsh-syntax-highlighting \
  /usr/share/zsh/plugins/zsh-syntax-highlighting \
  /opt/homebrew/share/zsh-syntax-highlighting \
  /usr/local/share/zsh-syntax-highlighting; do
  [[ -f "$dir/zsh-syntax-highlighting.zsh" ]] && source "$dir/zsh-syntax-highlighting.zsh" && break
done

# fzf keybindings
for dir in \
  /usr/share/doc/fzf/examples \
  /usr/share/fzf \
  /opt/homebrew/opt/fzf/shell \
  /usr/local/opt/fzf/shell; do
  [[ -f "$dir/key-bindings.zsh" ]] && source "$dir/key-bindings.zsh" && break
done

for dir in \
  /usr/share/doc/fzf/examples \
  /usr/share/fzf \
  /opt/homebrew/opt/fzf/shell \
  /usr/local/opt/fzf/shell; do
  [[ -f "$dir/completion.zsh" ]] && source "$dir/completion.zsh" && break
done
