FROM jupyterhub/singleuser:latest

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git htop p7zip-full tar unzip zip make \
    ca-certificates curl wget neovim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY pip.conf /etc/pip.conf

USER ${NB_UID}
