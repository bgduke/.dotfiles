# Breno Nord Dark SDDM Theme

A minimal SDDM theme using a Nord dark palette and a 2560×1440 wallpaper.

Install:

```bash
sudo unzip breno-sddm-theme-nord-dark-1440p.zip -d /usr/share/sddm/themes/
sudo mkdir -p /etc/sddm.conf.d
printf "[Theme]\nCurrent=breno-sddm-theme\n" | sudo tee /etc/sddm.conf.d/theme.conf
```

Test:

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/breno-sddm-theme
```
