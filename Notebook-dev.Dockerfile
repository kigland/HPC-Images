FROM jupyterhub/singleuser:latest

LABEL maintainer="kevin@kig.land"

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git htop btop p7zip-full tar unzip zip make \
    libgl1 libglx-mesa0 ffmpeg libsm6 libxext6 \
    ca-certificates curl wget neovim iputils-ping dnsutils \
    nano neovim

RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba clean --all -f -y && \
    jupyter lab clean && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY pip.conf /etc/pip.conf

USER ${NB_UID}

EXPOSE 22

COPY start-nb-with-ssh.sh /usr/local/bin/

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/usr/local/bin/start-nb-with-ssh.sh"]