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

NOVNC_VERSION=1.4.0
TURBOVNC_VERSION=3.1

# Generate a token at startup: it is the VNC password and is required by the Desktop launcher (NOVNC_TOKEN)
cp resources/vnc/start-notebook-genvnctoken.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-genvnctoken.sh

curl -sSfL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -zxf - -C /opt
mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC
# Fix VNC client
install -m 644 resources/vnc/vnc.html /opt/noVNC/vnc.html
install -m 644 resources/vnc/ui.js /opt/noVNC/app/ui.js

wget -q "https://github.com/TurboVNC/turbovnc/releases/download/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb" -O turbovnc.deb
apt-get update --quiet
apt-get install --quiet --yes --no-install-recommends ./turbovnc.deb
rm ./turbovnc.deb
ln -s /opt/TurboVNC/bin/* /usr/local/bin/

# Customize Desktop
mkdir -p /opt/vre /etc/xdg/xfce4/xfconf
cp resources/branding/desktop/wallpaper.png /opt/vre/wallpaper.png
cp -r resources/branding/desktop/xfce-perchannel-xml /etc/xdg/xfce4/xfconf/
chmod 664 /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/*

# Fix missing rebind.so issue
git clone --quiet https://github.com/novnc/websockify.git /opt/websockify
make -C /opt/websockify
cp /opt/websockify/rebind.so /usr/local/bin

# Remove logout desktop icon and screensaver
rm -f /usr/share/applications/xfce4-session-logout.desktop
apt-get purge --quiet --yes xfce4-screensaver || true
# Remove lite client as the full client is the one being used in the Desktop Launcher
rm /opt/noVNC/vnc_lite.html
