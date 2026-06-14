# =========================================
# Zsh Config - Mixed Minimal Dev Setup
# =========================================

# -----------------------------------------
# Auto-start Sway on tty1
# -----------------------------------------
if [[ -o interactive ]]; then
  if [[ "$(tty)" == "/dev/tty1" ]]; then
    if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
      exec sway
    fi
  fi
fi

# -----------------------------------------
# Environment
# -----------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=kitty
export BROWSER=firefox
export MANROFFOPT="-c"

if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# -----------------------------------------
# PATH
# -----------------------------------------
path=(
  "$HOME/.local/bin"
  "$HOME/.scripts"
  "$HOME/.cargo/bin"
  "$HOME/Applications/depot_tools"
  "$HOME/root/.dotnet/tools"
  "$HOME/.dotnet/tools"
  "$HOME/.nvm"
  "$HOME/.npm-global/bin"
  "$HOME/.npm/bin"
  "$HOME/node_modules/.bin"
  $path
)

typeset -U path
export PATH

# -----------------------------------------
# Fish-like completion
# -----------------------------------------
fpath=(/usr/share/zsh/site-functions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

bindkey -e
bindkey '^I' expand-or-complete

# Keep editing keys explicit so EDITOR=nvim does not switch zsh into vi mode.
[[ -n "${terminfo[kbs]}" ]] && bindkey -- "${terminfo[kbs]}" backward-delete-char
[[ -n "${terminfo[kdch1]}" ]] && bindkey -- "${terminfo[kdch1]}" delete-char
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char

# -----------------------------------------
# Fish-like history
# -----------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt BANG_HIST
setopt HIST_VERIFY

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
[[ -n "${terminfo[khome]}" ]] && bindkey -- "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey -- "${terminfo[kend]}" end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
[[ -n "${terminfo[kpp]}" ]] && bindkey -- "${terminfo[kpp]}" up-line-or-beginning-search
[[ -n "${terminfo[knp]}" ]] && bindkey -- "${terminfo[knp]}" down-line-or-beginning-search
bindkey '^[[5~' up-line-or-beginning-search
bindkey '^[[6~' down-line-or-beginning-search

# -----------------------------------------
# Fish-like autosuggestions
# -----------------------------------------
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -----------------------------------------
# Fish-like syntax highlighting
# Keep this near the end.
# -----------------------------------------
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -----------------------------------------
# Greeting
# -----------------------------------------
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
  sleep 0.1 && fastfetch --pipe false
fi

# -----------------------------------------
# Useful functions
# -----------------------------------------
history() {
  builtin history -i "$@"
}

backup() {
  cp "$1" "$1.bak"
}

copy() {
  if [[ "$#" -eq 2 && -d "$1" ]]; then
    local from="${1%/}"
    local to="$2"
    command cp -r "$from" "$to"
  else
    command cp "$@"
  fi
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar -xvzf "$1" ;;
    *.tar.xz)       tar -xvJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.rar)          unrar x "$1" ;;
    *)              echo "Unsupported archive" ;;
  esac
}

# -----------------------------------------
# Aliases
# -----------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -al --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias ll='eza -lg --icons=always --group-directories-first'
  alias lt='eza -aT --icons=always --group-directories-first'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'

alias jctl='journalctl -p 3 -xb'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

alias hw='hwinfo --short'

alias wget='wget -c'
alias tarnow='tar -acf'
alias untar='tar -zxvf'

alias v='nvim'
alias c='clear'

alias ff='fastfetch'
alias tm='tmux'
alias tma='tmux a'
alias tmn='tmux new-session'

# -----------------------------------------
# Zoxide integration
# -----------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# -----------------------------------------
# Direnv integration
# -----------------------------------------
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# -----------------------------------------
# Node Version Manager
# -----------------------------------------
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh" --no-use
elif [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh" --no-use
fi

# Add active npm global bin after nvm loads
if command -v npm >/dev/null 2>&1; then
  npm_global_bin="$(npm bin -g 2>/dev/null)"
  if [[ -n "$npm_global_bin" && -d "$npm_global_bin" ]]; then
    path=("$npm_global_bin" $path)
    typeset -U path
    export PATH
  fi
fi

# -----------------------------------------
# Starship prompt
# -----------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
