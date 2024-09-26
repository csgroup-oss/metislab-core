#!/bin/bash
# Copyright 2022 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# Copy files generated with user creation if not present
SAVED_HOME=/opt/vre/home/ai4geo
if [ -d $SAVED_HOME ]; then
  shopt -s dotglob # Allow hiddenfiles to be listed
  for file in $SAVED_HOME/*; do
    if [ ! -f $HOME/$(basename $file) ]; then
      echo "INFO: Copy $file to $HOME"
      cp $file $HOME
    fi
  done
fi
