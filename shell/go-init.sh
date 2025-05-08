#!/bin/bash

curl -LO https://mirrors.ustc.edu.cn/golang/go1.24.3.linux-amd64.tar.gz -A "OpenHPC/0.1.0"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

export PATH=$PATH:/usr/local/go/bin
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

echo 'use source ~/.bashrc to enable go'
