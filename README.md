# Dotfiles

Terminal setup optimized for development on WSL, Linux, and macOS.

## One-liner setup

```bash
git clone https://github.com/symphotonn/dotfiles.git ~/dotfiles && ~/dotfiles/setup.sh
```

## What's included

### Tools installed
| Tool | Purpose | Key usage |
|------|---------|-----------|
| **zsh** | Shell | Default shell |
| **starship** | Prompt | Shows git branch, lang versions, cmd duration |
| **fzf** | Fuzzy finder | `Ctrl+R` history, `Ctrl+T` files, `Alt+C` cd |
| **zoxide** | Smart cd | `z project` jumps to ~/long/path/to/project |
| **eza** | Modern ls | `ls`, `ll`, `tree` (aliased) |
| **bat** | Syntax cat | `cat file.py` (aliased) |
| **fd** | Fast find | `fd pattern` |
| **ripgrep** | Fast grep | `rg "search term"` |
| **tmux** | Terminal multiplexer | Sessions, splits, persist across disconnects |
| **gh** | GitHub CLI | `gh pr create`, `gh issue list` |

### Config files
| File | Purpose |
|------|---------|
| `.zshrc` | Zsh config with aliases, completions, tool integrations |
| `.tmux.conf` | Tmux with Alt-key shortcuts (no prefix needed for common ops) |
| `.config/starship.toml` | Minimal prompt showing only what matters |
| `zsh-compat.zsh` | Cross-platform zsh plugin path detection |
| `.zshrc.local` | (create manually) Machine-specific overrides, not tracked |

### Tmux shortcuts
| Key | Action |
|-----|--------|
| `Alt + \` | Split right |
| `Alt + -` | Split down |
| `Alt + arrows` | Switch pane |
| `Alt + z` | Zoom pane (fullscreen) |
| `Alt + w` | Close pane |
| `Alt + t` | New window |
| `Alt + 1-5` | Jump to window |
| `Alt + n/p` | Next/prev window |
| `Ctrl+Space` | Prefix (for rare commands: `d` detach, `$` rename, `[` copy mode) |

## Platform support

| Platform | Status |
|----------|--------|
| Ubuntu/Debian (WSL2) | Fully tested |
| Ubuntu/Debian (native) | Supported |
| Fedora | Supported |
| Arch/Manjaro | Supported |
| macOS (Homebrew) | Supported |

## WSL-specific notes

- **Proxy**: If Clash is running with mirrored networking on port 7897, `setup.sh` auto-detects and configures apt proxy.
- **DNS fake-ip**: The `198.18.0.x` IPs are Clash fake-ip — apt must go through the proxy.
- `.zshrc` auto-detects WSL and sets proxy env vars accordingly.

## Local overrides

Create `~/.zshrc.local` for machine-specific config (API keys, extra PATH, etc.). This file is sourced last and not tracked in git.

```bash
# Example ~/.zshrc.local
export ANTHROPIC_API_KEY="sk-..."
export PATH="$HOME/custom/bin:$PATH"
```

## AI setup guide

If you're an AI assistant helping set up this environment:

1. Clone: `git clone https://github.com/symphotonn/dotfiles.git ~/dotfiles`
2. Run: `~/dotfiles/setup.sh` (needs sudo for package install)
3. If on WSL with Clash proxy issues, the script handles it automatically
4. After setup, user should run `exec zsh` or restart terminal
5. Machine-specific config goes in `~/.zshrc.local`
6. If packages fail to install, check proxy/network first
