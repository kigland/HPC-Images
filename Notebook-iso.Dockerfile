FROM jupyterhub/singleuser:latest

LABEL maintainer="kevin@kig.land"

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git htop p7zip-full tar unzip zip make screen \
    libgl1 libglx-mesa0 ffmpeg libsm6 libxext6 \
    ca-certificates curl wget neovim iputils-ping dnsutils \
    nano neovim

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba clean --all -f -y && \
    jupyter lab clean && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

COPY start-nb-base.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start-nb-base.sh

COPY pip.conf /etc/pip.conf

COPY ubuntu.sources /etc/apt/sources.list.d

USER ${NB_UID}

RUN sed -i '/eval "$(conda shell.bash hook)"/c\export PATH="/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:$PATH"\neval "$(conda shell.bash hook)"' ~/.bashrc

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/usr/local/bin/start-nb-base.sh"]