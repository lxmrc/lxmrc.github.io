---
layout: page
title: Linux Setup
permalink: /linux-setup
---

1. Swap Ctrl and Caps Lock

`~/.config/autostart/xmodmap.desktop`:

```
[Desktop Entry]
Name[en_US].xmodmap-thinkpad
Comment[en_US]=xmodmap ~/.xmodmap-thinkpad
Exec=/usr/bin/xmodmap .xmodmap-thinkpad
Icon=application-default-icon
X-GNOME-Autostart-enabled=true
Type=Application
```

1. Disable password for `sudo`: `$USER ALL = NOPASSWD : ALL`

1. Install Guake

1. Get dotfiles

1. Install `fzf` and `ripgrep`

1. Modify user directories: `~/.config/user-dirs.dirs`

1. Change hostname: `/etc/hostname`, `/etc/hosts`
