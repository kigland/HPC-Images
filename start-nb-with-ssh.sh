#!/bin/bash
# Copyright (c) 2025 Xiang Shi (KevinZonda) & KigLand

set -e

OHPC_FOLDER="/etc/ohpc"
PASSWORD_CHANGED_FLAG="$OHPC_FOLDER/password_changed"

if [ -n "$JUPYTER_TOKEN" ] && [ ! -f "$PASSWORD_CHANGED_FLAG" ]; then
    echo "jovyan:$JUPYTER_TOKEN" | sudo chpasswd
    if [ ! -d OHPC_FOLDER ]; then
        sudo mkdir -p "$OHPC_FOLDER" > /dev/null
    fi
    echo '1' | sudo tee "$PASSWORD_CHANGED_FLAG" > /dev/null
    sudo chown jovyan:users "$PASSWORD_CHANGED_FLAG"
    sudo chmod 444 "$PASSWORD_CHANGED_FLAG"
else
    if [ -f "$PASSWORD_CHANGED_FLAG" ]; then
        echo "password is ready."
    fi
fi

sudo /usr/sbin/sshd -D &

# Check if NB_VAR_BASE_URL is set
if [ -z "$NB_VAR_BASE_URL" ]; then
    exec start-notebook.sh
else
    exec start-notebook.sh --NotebookApp.base_url="$NB_VAR_BASE_URL"
fi
