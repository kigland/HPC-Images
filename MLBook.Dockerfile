FROM jupyterhub/singleuser:latest

WORKDIR /tmp

RUN mamba install -y \
    pytorch \
    tensorflow \
    keras \
    numpy \
    seaborn \
    pandas \
    matplotlib

RUN mamba clean --all -f -y && \
    jupyter lab clean && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}
WORKDIR "${HOME}"