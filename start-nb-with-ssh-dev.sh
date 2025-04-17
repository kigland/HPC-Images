#!/bin/bash
# Copyright (c) Xiang Shi (KevinZonda) & KigLand

set -e

if [ -n "$JUPYTER_TOKEN" ]; then
    echo -e "password\n$JUPYTER_TOKEN\n$JUPYTER_TOKEN" | passwd jovyan
else
    RANDOM_PASSWORD=$(openssl rand -base64 32)
    echo -e "password\n$RANDOM_PASSWORD\n$RANDOM_PASSWORD" | passwd jovyan
    echo "user password: $RANDOM_PASSWORD" > /home/jovyan/password.txt
    chmod 600 /home/jovyan/password.txt
    echo "Password saved to /home/jovyan/password.txt"
fi

/usr/sbin/sshd -D &

# Check if NB_VAR_BASE_URL is set
if [ -z "$NB_VAR_BASE_URL" ]; then
    exec start-notebook.sh
else
    exec start-notebook.sh --NotebookApp.base_url="$NB_VAR_BASE_URL"
fi
