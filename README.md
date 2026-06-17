# Dotfiles
A vault for all my dotfiles I've made along these years, tho I don't use all of them.
These are the relevant .dotfiles for my current setup:

### General
 - nvim
 - ideavim
 - scripts
 - fastfetch
 - starship

### Linux
 - sway
 - swaylock
 - waybar
 - alacritty
 - fish
 - tmux
 - rofi
 - dunst
 - themes
 - locals
 - gtk

### Windows
 - glazewm
 - yasb
 - vsvim
 - powershell
 - psmux

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
This will delete the current config for all Windows and General dotfiles if they exists, and create a symbolic link to them in the dotfiles repository.

### Manual
If you don't wan't a symbolic link to my repo, just copy the config file/folder manually.

# Scripts
The bash and powershell scripts were made to serve **my own use cases**, even tho I'm sharing them, read each before running them. 
**I won't be responsible** if my script does something you don't expect, since I made them for myself.
