#!/bin/bash
# Copyright 2022 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# `conda init` does nothing if already done once
conda init
conda config --set auto_activate_base false
export CONDA_ENVS_PATH=$HOME/.conda/envs
export CONDA_PKGS_DIRS=$HOME/.conda/pkgs
