#!/bin/bash
# Copyright 2024 CS GROUP - France, http://www.c-s.fr
# All rights reserved

set -e

# Startup scripts (sourced by /srv/start)
cp resources/jupyter-scripts/start-notebook-*.sh resources/jupyter-scripts/start-singleuser.sh /usr/local/bin/
chmod 755 /usr/local/bin/start-notebook-*.sh /usr/local/bin/start-singleuser.sh
cp resources/bash.bashrc /etc/

# Jupyterlab launcher shortcuts resources
mkdir -p /opt/vre/jupyterlab_shortcuts
cp resources/jupyterlab_shortcuts/docs-vre.svg /opt/vre/jupyterlab_shortcuts/

# Tests resources
mkdir -p /opt/vre/tests
cp resources/tests/* /opt/vre/tests/
chmod -R +rX /opt/vre/
