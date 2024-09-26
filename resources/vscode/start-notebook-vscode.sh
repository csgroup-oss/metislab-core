#!/bin/bash
# Copyright 2022 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# VSCode base extensions copy if not already set
VSCODE_EXTENSIONS_DIR=$HOME/.vscode/extensions
echo "INFO: VSCode extensions folder set up in $VSCODE_EXTENSIONS_DIR"
mkdir -p $VSCODE_EXTENSIONS_DIR
echo "INFO: Avoiding extensions auto update by overriding user settings"
python /opt/code-server/user-settings.py $HOME/.local/share/code-server/User/settings.json
echo "INFO: Copy of VSCode base extensions"
rsync -a /opt/code-server/extensions/ $VSCODE_EXTENSIONS_DIR
echo "INFO: VSCode extensions successfully set up"
