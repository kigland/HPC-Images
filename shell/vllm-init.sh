#!/bin/bash

sudo apt update
sudo apt install -y build-essential
pip install vllm flashinfer-python
pip install modelscope

echo 'export VLLM_USE_MODELSCOPE=True' >> ~/.bashrc
