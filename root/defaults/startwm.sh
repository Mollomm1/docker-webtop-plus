#!/bin/bash
setterm blank 0
setterm powerdown 0
export XDG_SESSION_TYPE=x11
export DESKTOP_SESSION=ubuntu
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME

sudo service dbus start
export $(dbus-launch)
export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/config/.local/share/flatpak/exports/share:/usr/local/share:/usr/share

if [ ! -f "/config/.firstsetup" ]; then
    # Execute commands
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    dconf load / < /defaults/gnome.dconf.conf # fix de
    sudo rm -rf /config/.cache # fix firefox
    cp /defaults/.bashrc /config/.bashrc
    mkdir -p /config/.config/gtk-3.0/ /config/.config/gtk-4.0/
    echo -e "[Settings]\ngtk-application-prefer-dark-theme=1\ngtk-icon-theme-name=Yaru-dark\ngtk-theme-name=Yaru-dark\ngtk-cursor-theme-name=Yaru\ngtk-sound-theme-name=Yaru" > ~/.config/gtk-4.0/settings.ini # fix dark theme
    echo -e "[Settings]\ngtk-application-prefer-dark-theme=1\ngtk-icon-theme-name=Yaru-dark\ngtk-theme-name=Yaru-dark\ngtk-cursor-theme-name=Yaru\ngtk-sound-theme-name=Yaru" > ~/.config/gtk-3.0/settings.ini # fix dark theme
    mkdir /config/Desktop /config/Documents /config/Downloads /config/Music /config/Pictures /config/Public /config/Templates /config/Videos
    chmod 755 /config/Desktop /config/Documents /config/Downloads /config/Music /config/Pictures /config/Public /config/Templates /config/Videos
    cp /defaults/README.md /config/Desktop/README.md
    touch /config/.firstsetup
fi

gnome-shell --x11 -r > /dev/null 2>&1