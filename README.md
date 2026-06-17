# Dotfiles
A vault for all my dotfiles I've made along these years, tho I don't use all of them.

|OS|Type|Dotfile|In Use|
|--|--|--|:---:|
|Any|Editor|nvim|✔️|
|Any|Editor|ideavim|✔️|
|Any|Editor|zed|❌|
|Any|CLI App|fastfetch|✔️|
|Any|CLI App|starship|✔️|
|Any|CLI App|zellij|❌|
|Any|Folder|scripts|✔️|
|Linux|TWM|sway|✔️|
|Linux|TWM|hypr|❌|
|Linux|TWM Lock|swaylock|✔️|
|Linux|TWM Statusbar|waybar|✔️|
|Linux|TWM Launcher|rofi|✔️|
|Linux|TWM Daemon|dunst|✔️|
|Linux|Terminal|alacritty|✔️|
|Linux|Terminal|kitty|❌|
|Linux|Shell|fish|✔️|
|Linux|Shell|zsh|❌|
|Linux|CLI App|tmux|✔️|
|Linux|Folder|themes|✔️|
|Linux|Folder|locals|✔️|
|Linux|Folder|gtk|✔️|
|Windows|TWM|glazewm|✔️|
|Windows|TWM Statusbar|yasb|✔️|
|Windows|Editor|vsvim|✔️|
|Windows|Shell|powershell|✔️|
|Windows|CLI App|psmux|✔️|
|Windows|Terminal|wezterm|✔️|

# Installation
### Linux
Install through **GNU Stow** by running the command bellow.
```sh
stow -S <package_name>
```

### Windows
Install through `link-windows-dotfiles.ps1` inside scripts folder.
```sh
sudo pwsh .\link-windows-dotfiles.ps1
```
You'll need either to enable **sudo** or be in a admin elevated shell to run it.
This will delete the current config for all Windows and Any dotfiles if they exists, and create a symbolic link to them in the dotfiles repository.

### Manual
If you don't wan't a symbolic link to my repo, just copy the config file/folder manually.

# Scripts
The bash and powershell scripts were made to serve **my own use cases**, even tho I'm sharing them, read each before running them. 
**I won't be responsible** if my script does something you don't expect, since I made them for myself.
