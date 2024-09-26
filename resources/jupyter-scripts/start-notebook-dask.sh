#!/bin/bash
# Copyright 2022 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# Dask-jobqueue configuration for dask-labextension
# see https://jobqueue.dask.org/en/latest/interactive.html#configuration
echo "[INFO] setting dask-labextension..."
DASK_CFG_FILE=$HOME/.config/dask/jobqueue.yaml
mkdir -p $(dirname $DASK_CFG_FILE)
if [[ ! -f $DASK_CFG_FILE ]]; then
    echo "[INFO] $DASK_CFG_FILE not existing, creating"
    touch $DASK_CFG_FILE
fi
if [[ -z $(grep distributed.dashboard.link $DASK_CFG_FILE) ]]; then
    echo "" >> $DASK_CFG_FILE
    echo "distributed.dashboard.link: "/user/{JUPYTERHUB_USER}/proxy/{port}/status"" >> $DASK_CFG_FILE
    echo "" >> $DASK_CFG_FILE
else
    echo "[WARN] dask-labextension already configured"
    echo "[WARN] remove "distributed.dashboard.link" setting from $DASK_CFG_FILE if you want to reapply"
fi
echo "[INFO] dask-labextension successfully configured"
