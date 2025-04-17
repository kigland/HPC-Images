FROM jupyterhub/singleuser:latest

LABEL maintainer="kevin@kig.land"

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    git htop btop p7zip-full tar unzip zip make screen \
    libgl1 libglx-mesa0 ffmpeg libsm6 libxext6 \
    ca-certificates curl wget neovim iputils-ping dnsutils \
    nano neovim

RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 8822/' /etc/ssh/sshd_config

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mamba clean --all -f -y && \
    jupyter lab clean && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN echo "jovyan:password" | chpasswd

# RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY start-nb-with-ssh-dev.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start-nb-with-ssh-dev.sh

COPY pip.conf /etc/pip.conf

COPY ubuntu.sources /etc/apt/sources.list.d

USER ${NB_UID}

RUN sed -i '/eval "$(conda shell.bash hook)"/c\export PATH="/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:$PATH"\neval "$(conda shell.bash hook)"' ~/.bashrc

EXPOSE 8822

ENTRYPOINT ["tini", "-g", "--"]
CMD ["/usr/local/bin/start-nb-with-ssh-dev.sh"]
