#!/bin/bash

if [ -n "$JUPYTER_TOKEN" ]; then
    echo "jovyan:$JUPYTER_TOKEN" | sudo chpasswd
fi

sudo /usr/sbin/sshd -D &

exec start-notebook.sh