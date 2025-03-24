FROM jupyterhub/singleuser:latest

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git htop p7zip-full tar unzip zip make \
    libgl1-mesa-glx ffmpeg libsm6 libxext6 \
    ca-certificates curl wget neovim iputils-ping dnsutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba clean --all -f -y && \
    jupyter lab clean && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY pip.conf /etc/pip.conf

USER ${NB_UID}
