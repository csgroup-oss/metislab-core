#!/bin/bash
# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved
# Inspired by https://github.com/jupyter/docker-stacks/blob/master/base-notebook

set -e

# Exec startup scripts files
echo "[INFO] Executing up startup scripts"
for file in /usr/local/bin/*
do
  if [[ $file == *"start-notebook-"* ]]
  then
    echo "[INFO] Executing $file"
    source "$file"
  fi
done
echo "[INFO] Executing up startup scripts - Finished"

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # drop first arg from $@ which is jupyter-singleuser command set by JupyterHub
  shift
  # launched by JupyterHub, use single-user entrypoint
  exec start-singleuser.sh "$@"
elif [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
  jupyter lab "$@"
else
  jupyter notebook "$@"
fi
