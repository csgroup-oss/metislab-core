#!/bin/bash
# Copyright 2024 CS GROUP - France, http://www.c-s.fr
# All rights reserved

set -e

mkdir -p /opt/code-server
cd /opt/code-server
curl -fsSL https://code-server.dev/install.sh | \
    sh -s -- --prefix /opt/code-server/ --method standalone
export PATH=/opt/code-server/bin:$PATH
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt

# VSCode extensions
# Python code used to override the user settings conf in order to avoid extensions auto update
cd "$HOME"
cp resources/vscode/user-settings.py /opt/code-server/user-settings.py
cp resources/vscode/start-notebook-vscode.sh /usr/local/bin/
cp resources/vscode/install-extensions.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-vscode.sh /usr/local/bin/install-extensions.sh
export VSCODE_EXTENSIONS=/opt/code-server/extensions
install-extensions.sh
