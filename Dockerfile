FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mollomm1"

ENV TITLE="Ubuntu 24.04 Gnome"

COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

COPY /root/ /

RUN \
  echo "**** install packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  apt-get install -y \
    firefox \
    fonts-ubuntu \
    gnome-shell \
    gnome-shell-* \
    dbus-x11 \
    gnome-terminal \
    gnome-accessibility-themes \
    gnome-calculator \
    gnome-control-center* \
    gnome-desktop3-data \
    gnome-initial-setup \
    gnome-menus \
    gnome-themes-extra* \
    gnome-user-docs \
    gnome-video-effects \
    gnome-tweaks \
    gnome-software \
    language-pack-en-base \
    mesa-utils \
    xdg-desktop-portal \
    flatpak \
    gnome-software \
    gnome-software-plugin-flatpak \
    yaru-* \
    ubuntu-desktop 
  # you can remove ubuntu-desktop if you dont want the 'bloat'.

RUN \
  echo "**** apply fixes ****" && \
  for file in $(find /usr -type f -iname "*login1*"); do mv -v $file "$file.back"; done && \
  chown abc /defaults/wallpaper.jpg && \
  echo "\n# fixes and stuff for gnome and flatpaks\nexport $(dbus-launch)\nexport XDG_CURRENT_DESKTOP=ubuntu:GNOME\nexport XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/config/.local/share/flatpak/exports/share:/usr/local/share:/usr/share\nexport XDG_SESSION_TYPE=x11\nexport DESKTOP_SESSION=ubuntu\nexport GNOME_SHELL_SESSION_MODE=ubuntu" >> /etc/profile && \
  mv -v /usr/share/applications/gnome-sound-panel.desktop /usr/share/applications/gnome-sound-panel.desktop.back && \
  mv -v /usr/share/applications/gnome-color-panel.desktop /usr/share/applications/gnome-color-panel.desktop.back && \
  mv -v /usr/share/applications/gnome-power-panel.desktop /usr/share/applications/gnome-power-panel.desktop.back && \
  mv -v /usr/share/applications/gnome-bluetooth-panel.desktop /usr/share/applications/gnome-bluetooth-panel.desktop.back && \
  mv -v /usr/share/applications/gnome-network-panel.desktop /usr/share/applications/gnome-network-panel.desktop.back && \
  mv -v /usr/share/applications/gnome-printers-panel.desktop /usr/share/applications/gnome-printers-panel.desktop.back

RUN \
  echo "**** clean stuff ****" && \
  apt-get remove -y \
    gnome-power-manager \
    gnome-bluetooth \
    mailnag gnome-shell-mailnag \
    xterm \
    gnome-software-plugin-snap \
    snapd && \
  apt autoremove -y &&\
  apt clean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# ports and volumes
EXPOSE 3000

VOLUME /config
