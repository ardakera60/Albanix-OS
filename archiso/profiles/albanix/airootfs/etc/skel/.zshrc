# .zshrc — Albanix OS live user shell (zsh + starship)
# Runs in the LIVE ISO and is copied to installed users by Calamares.

# Fastfetch on first terminal open (per theme).
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --config albanix
fi

# Starship prompt (per-theme config at ~/.config/starship.toml).
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Useful aliases.
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias update='sudo albanix update'
alias theme='albanix theme'
alias bench='albanix bench'
alias info='albanix info'

# History.
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Albanian-friendly completion.
autoload -Uz compinit && compinit