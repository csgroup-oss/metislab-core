#!/bin/bash
# Copyright 2024 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# Firefox from the official Mozilla APT repository
# (the Ubuntu package is a snap transitional package, not usable in a container)
set -e

install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O /etc/apt/keyrings/packages.mozilla.org.asc
cat > /etc/apt/sources.list.d/mozilla.sources <<SOURCES
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
SOURCES
cat > /etc/apt/preferences.d/mozilla <<PREFS
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
PREFS

apt-get update --quiet
apt-get install --quiet --yes --no-install-recommends firefox
