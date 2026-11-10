#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.
set -e

# noVNC setup
# See also:
# * https://github.com/manics/jupyter-omeroanalysis-desktop
# * https://github.com/ml-tooling/ml-workspace

apt-get update --quiet
apt-get install --quiet --yes --no-install-recommends \
    # provides add-apt-repository
    software-properties-common
add-apt-repository ppa:mozillateam/ppa --yes
apt-get update --quiet
DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    dconf-cli \
    dbus-x11 \
    evince \
    file-roller \
    firefox-esr \
    geeqie \
    thunar-archive-plugin \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme

curl -sSfL https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -zxf - -C /opt
# Fix VNC client
chmod o+r /opt/vnc.html
chmod o+r /opt/ui.js
mv /opt/vnc.html /opt/noVNC-1.2.0
mv /opt/ui.js /opt/noVNC-1.2.0/app
wget 'https://sourceforge.net/projects/turbovnc/files/2.2.5/turbovnc_2.2.5_amd64.deb/download' -O turbovnc_2.2.5_amd64.deb
apt-get install -y -q ./turbovnc_2.2.5_amd64.deb
rm ./turbovnc_2.2.5_amd64.deb
ln -s /opt/TurboVNC/bin/* /usr/local/bin/
pip install --quiet --upgrade "websockify~=0.10"
# Fix missing rebind.so issue
cd /opt && git clone --quiet https://github.com/novnc/websockify.git
cd /opt/websockify && make && cp rebind.so /usr/local/bin
# Remove mail and logout desktop icons
rm /usr/share/applications/xfce4-session-logout.desktop
apt purge --quiet --yes xfce4-screensaver
# Remove lite client as the full client is the one being used in the Desktop Launcher
rm /opt/noVNC-1.2.0/vnc_lite.html

# Customize Desktop
mkdir -p /opt/vre
cp resources/branding/desktop/wallpaper.png /opt/vre/wallpaper.png
mkdir -p /etc/xdg/xfce4/xfconf
cp -r resources/branding/desktop/xfce-perchannel-xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml
chmod 664 /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/*
