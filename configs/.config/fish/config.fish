# =========================================
# Fish Config - Mixed Minimal Dev Setup
# =========================================

if not status is-interactive
    exit
end

# done.fish settings
set -U __done_min_cmd_duration 8000
set -U __done_notification_urgency_level low
set -U __done_notify_sound 0

# Ignore spammy commands
set -U __done_exclude '^git (?!push|pull|fetch)|^ls|^cd|^clear'

# Better support for sway
set -U __done_sway_ignore_visible 1

# -----------------------------------------
# Greeting
# -----------------------------------------
function fish_greeting
    if type -q fastfetch
        fastfetch
    end
end

# -----------------------------------------
# Environment
# -----------------------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL kitty
set -gx BROWSER firefox

# Better man pages
set -gx MANROFFOPT "-c"

if type -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# -----------------------------------------
# PATH
# -----------------------------------------
fish_add_path \
    ~/.local/bin \
    ~/.cargo/bin \
    ~/Applications/depot_tools \
    ~/root/.dotnet/tools

# -----------------------------------------
# History shortcuts (!! and !$)
# -----------------------------------------
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if test "$fish_key_bindings" = fish_vi_key_bindings
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# -----------------------------------------
# Useful functions
# -----------------------------------------

# Better history timestamps
function history
    builtin history --show-time='%F %T ' $argv
end

# Quick backup
function backup --argument filename
    cp $filename $filename.bak
end

# Smart copy
function copy
    set count (count $argv | tr -d '\n')

    if test "$count" = 2; and test -d "$argv[1]"
        set from (string trim -r -c / $argv[1])
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

# mkdir + cd
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# Extract archives easily
function extract
    switch $argv[1]
        case "*.tar.gz" "*.tgz"
            tar -xvzf $argv[1]
        case "*.tar.xz"
            tar -xvJf $argv[1]
        case "*.zip"
            unzip $argv[1]
        case "*.rar"
            unrar x $argv[1]
        case "*"
            echo "Unsupported archive"
    end
end

# -----------------------------------------
# Aliases
# -----------------------------------------

# eza replacements
if type -q eza
    alias ls='eza -al --icons=always --group-directories-first'
    alias la='eza -a --icons=always --group-directories-first'
    alias ll='eza -lg --icons=always --group-directories-first'
    alias lt='eza -aT --icons=always --group-directories-first'
end

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
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'

# System
alias jctl='journalctl -p 3 -xb'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Hardware
alias hw='hwinfo --short'

# Quick uploads
alias tb='nc termbin.com 9999'

# Files
alias wget='wget -c'
alias tarnow='tar -acf'
alias untar='tar -zxvf'

# Dev
alias v='nvim'
alias c='clear'

# -----------------------------------------
# Zoxide integration
# -----------------------------------------
if type -q zoxide
    zoxide init fish | source
end

# -----------------------------------------
# Direnv integration
# -----------------------------------------
if type -q direnv
    direnv hook fish | source
end

# -----------------------------------------
# Starship prompt
# -----------------------------------------
if type -q starship
    starship init fish | source
end
