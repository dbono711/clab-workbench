# The devcontainer will be based on Python 3.9
# The base container already has entrypoint, vscode user account, etc. out of the box
FROM mcr.microsoft.com/devcontainers/python:0-3.9-bullseye

# containelab version will be set in devcontainer.json
ARG _CLAB_VERSION

# install some basic tools inside the container
# adjust this list based on your demands
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sshpass \
    curl \
    iputils-ping \
    htop \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# install preferred version of the containerlab
RUN bash -c "$(curl -sL https://get.containerlab.dev)" -- -v ${_CLAB_VERSION} \
    && pip3 install --user yamllint
