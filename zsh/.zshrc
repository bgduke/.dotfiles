# =========================================
# Zsh Config - Mixed Minimal Dev Setup
# =========================================

# -----------------------------------------
# Auto-start Sway on tty1
# -----------------------------------------
if [[ -o interactive && "$(tty)" == /dev/tty1 ]]; then
  if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
    exec sway
  fi
fi

# -----------------------------------------
# Environment
# -----------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=kitty
export BROWSER=firefox

# Better man pages
export MANROFFOPT=-c

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# -----------------------------------------
# PATH
# -----------------------------------------
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.scripts"
  "$HOME/.cargo/bin"
  "$HOME/Applications/depot_tools"
  "$HOME/root/.dotnet/tools"
  "$HOME/.dotnet/tools"
  $path
)

# -----------------------------------------
# Pyenv
# -----------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  path=("$PYENV_ROOT/bin" $path)
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init -)"
fi

# -----------------------------------------
# Completion and key bindings
# -----------------------------------------
fpath=(/usr/share/zsh/site-functions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

bindkey -e
bindkey '^I' expand-or-complete

[[ -n "${terminfo[kbs]}" ]] && bindkey -- "${terminfo[kbs]}" backward-delete-char
[[ -n "${terminfo[kdch1]}" ]] && bindkey -- "${terminfo[kdch1]}" delete-char
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char

# -----------------------------------------
# History and Fish-like history search
# Zsh provides !! and !$ natively.
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

# Fish includes these features by default; load their Zsh plugins when present.
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -----------------------------------------
# Useful functions
# -----------------------------------------

# Better history timestamps
history() {
  builtin history -i "$@"
}

# Quick backup
backup() {
  cp "$1" "$1.bak"
}

# Smart copy
copy() {
  if (( $# == 2 )) && [[ -d "$1" ]]; then
    local from="${1%/}"
    local to="$2"
    command cp -r "$from" "$to"
  else
    command cp "$@"
  fi
}

# mkdir + cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract archives easily
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar -xvzf "$1" ;;
    *.tar.xz)       tar -xvJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.rar)          unrar x "$1" ;;
    *)              echo 'Unsupported archive' ;;
  esac
}

# -----------------------------------------
# Aliases
# -----------------------------------------

# eza replacements
if (( $+commands[eza] )); then
  alias ls='eza -al --icons=always --group-directories-first'
  alias la='eza -a --icons=always --group-directories-first'
  alias ll='eza -lg --icons=always --group-directories-first'
  alias lt='eza -aT --icons=always --group-directories-first'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Safer defaults
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Pacman / Arch
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'

# System
alias jctl='journalctl -p 3 -xb'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Hardware
alias hw='hwinfo --short'

# Files
alias wget='wget -c'
alias tarnow='tar -acf'
alias untar='tar -zxvf'

# Dev
alias v='nvim'
alias c='clear'

# Terminal
alias ff='fastfetch'
alias tm='tmux'
alias tma='tmux a'
alias tmn='tmux new-session'

# -----------------------------------------
# Zoxide integration
# -----------------------------------------
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

# -----------------------------------------
# Direnv integration
# -----------------------------------------
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# -----------------------------------------
# Starship prompt
# -----------------------------------------
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Keep syntax highlighting last among interactive plugins.
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -----------------------------------------
# Homebrew
# -----------------------------------------
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi
