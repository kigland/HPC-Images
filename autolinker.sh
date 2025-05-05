#!/bin/bash
# AutoLinker.sh
# Author: Xiang Shi
# Copyright (c) 2025 Xiang Shi, KigLand

if [ -d ~/rds/.cache ]; then
    ln -s ~/'rds/.cache' ~/'.cache' || true
    echo "[ OK ] .cache linked to rds"
fi

if [ -d ~/rds/.ssh ]; then
    if [ -e ~/.ssh ]; then
        echo "[WARN] ~/.ssh already exists, skip creating link"
    else
        ln -s ~/rds/.ssh ~/.ssh || true
        echo "[ OK ] .ssh linked to rds"
    fi
fi

if [ -e ~/rds/ohpc_init.sh ]; then
    bash ~/rds/ohpc_init.sh || true
fi
