#!/bin/bash
# Copyright (c) Xiang Shi (KevinZonda) & KigLand

set -e

if [ -n "$JUPYTER_TOKEN" ]; then
    echo "jovyan:$JUPYTER_TOKEN" | sudo chpasswd
fi

sudo /usr/sbin/sshd -D &

# Check if NB_VAR_BASE_URL is set
if [ -z "$NB_VAR_BASE_URL" ]; then
    exec start-notebook.sh
else
    exec start-notebook.sh --NotebookApp.base_url="$NB_VAR_BASE_URL"
fi
