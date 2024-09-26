#!/bin/bash

# Fonction retry
retry() {
  local -r -i max_attempts=10
  local -i attempt_num=1

  until "$@"; do
    if (( attempt_num == max_attempts )); then
      echo "Attempt $attempt_num failed! No more retries left."
      return 1
    else
      echo "Attempt $attempt_num failed! Trying again in 2 seconds..."
      sleep 2
    fi

    attempt_num=$(( attempt_num + 1 ))
  done
}

retry bash -c "mkdir -p $VSCODE_EXTENSIONS && \
    chmod +rX /opt/code-server/user-settings.py && \
    code-server --install-extension ms-toolsai.jupyter --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension ms-python.python --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension mhutchie.git-graph --extensions-dir $VSCODE_EXTENSIONS && \
    code-server --install-extension eamodio.gitlens --extensions-dir $VSCODE_EXTENSIONS && \
    layer-cleanup.sh"