# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

FROM ubuntu:22.04
LABEL maintainer="CS GROUP"

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

COPY resources/layer-cleanup.sh /usr/local/bin

# Add man and man pages
RUN \
    rm /etc/dpkg/dpkg.cfg.d/excludes \
    && \
    if  [ "$(dpkg-divert --truename /usr/bin/man)" = "/usr/bin/man.REAL" ]; then \
        # Remove diverted man binary
        rm -f /usr/bin/man; \
        dpkg-divert --quiet --remove --rename /usr/bin/man; \
    fi

# System librairies
RUN \
    apt-get update --quiet && \
    DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
        cmake \
        curl \
        dfc \
        file \
        git \
        gir1.2-gtk-3.0 \
        gnupg \
        gobject-introspection \
        graphviz \
        htop \
        iputils-ping \
        jq \
        less \
        lnav \
        mlocate \
        mousepad \
        nano \
        ncdu \
        openssh-client \
        python3-gi \
        python3-dev \
        python3-pip \
        python3-venv \
        ranger \
        rclone \
        rsync \
        scrot \
        silversearcher-ag \
        texlive-fonts-recommended \
        texlive-lang-french \
        texlive-latex-extra \
        texlive-plain-generic \
        texlive-xetex \
        tig \
        tmux \
        tree \
        unzip \
        vim \
        wget \
        && \
    layer-cleanup.sh

# Node setup
RUN \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --quiet --yes nodejs && \
    layer-cleanup.sh

# Install JupyterLab, JupyterHub and Jupyter Server Proxy
# JupyterHub is required for jupyterhub-singleuser command
COPY resources/nbproxy /opt/jupyter_proxy
RUN \
    chmod -R +rX /opt/jupyter_proxy && \
    wget -q https://upload.wikimedia.org/wikipedia/commons/5/5b/Xfce_logo.svg -O /opt/jupyter_proxy/jupyter_proxy/icons/xfce.svg && \
    chmod 664 /opt/jupyter_proxy/jupyter_proxy/icons/xfce.svg && \
    pip install --upgrade \
        "jupyter-server-proxy~=4.1" \
        "jupyterhub~=4.1" \
        "jupyterlab-git~=0.44" \
        "jupyterlab~=3.6" \
        /opt/jupyter_proxy \
        && \
    rm -rf /opt/jupyter_proxy && \
    layer-cleanup.sh

# Code server setup
RUN \
    cd /opt && \
    mkdir /opt/code-server && \
    cd /opt/code-server && \
    curl -fsSL https://code-server.dev/install.sh | \
        sh -s -- --prefix /opt/code-server/ --method standalone
ENV PATH=/opt/code-server/bin:$PATH

# VSCode extensions
# Python code used to override the user settings conf in order to avoid extensions auto update
COPY resources/vscode/user-settings.py /opt/code-server/user-settings.py
COPY resources/vscode/start-notebook-vscode.sh /usr/local/bin/
COPY resources/vscode/install-extensions.sh /usr/local/bin/
ENV VSCODE_EXTENSIONS=/opt/code-server/extensions
RUN install-extensions.sh

# noVNC setup
# See also:
# * https://github.com/manics/jupyter-omeroanalysis-desktop
# * https://github.com/ml-tooling/ml-workspace
COPY /resources/vnc /opt
RUN \
    apt-get update --quiet && \
    apt-get install --quiet --yes --no-install-recommends \
        # provides add-apt-repository
        software-properties-common && \
    add-apt-repository ppa:mozillateam/ppa --yes && \
    apt-get update --quiet && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
        dconf-cli \
        dbus-x11 \
        evince \
        file-roller \
        firefox-esr \
        geeqie \
        thunar-archive-plugin \
        xfce4 \
        xfce4-panel \
        xfce4-session \
        xfce4-settings \
        xorg \
        xubuntu-icon-theme \
        && \
    curl -sSfL https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar -zxf - -C /opt && \
    # Fix VNC client
    chmod o+r /opt/vnc.html && \
    chmod o+r /opt/ui.js && \
    mv /opt/vnc.html /opt/noVNC-1.2.0 && \
    mv /opt/ui.js /opt/noVNC-1.2.0/app && \
    wget 'https://sourceforge.net/projects/turbovnc/files/2.2.5/turbovnc_2.2.5_amd64.deb/download' -O turbovnc_2.2.5_amd64.deb && \
    apt-get install -y -q ./turbovnc_2.2.5_amd64.deb && \
    rm ./turbovnc_2.2.5_amd64.deb && \
    ln -s /opt/TurboVNC/bin/* /usr/local/bin/ && \
    pip install --quiet --upgrade "websockify~=0.10" && \
    # Fix missing rebind.so issue
    cd /opt && git clone --quiet https://github.com/novnc/websockify.git && \
    cd /opt/websockify && make && cp rebind.so /usr/local/bin && \
    # Remove mail and logout desktop icons
    rm /usr/share/applications/xfce4-session-logout.desktop && \
    apt purge --quiet --yes xfce4-screensaver && \
    # Remove lite client as the full client is the one being used in the Desktop Launcher
    rm /opt/noVNC-1.2.0/vnc_lite.html && \
    layer-cleanup.sh

# Customize Desktop
COPY resources/branding/desktop/wallpaper.png /opt/vre/wallpaper.png
COPY resources/branding/desktop/xfce-perchannel-xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml
RUN chmod 664 /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/*

# To make 'python' the system python version
RUN ln -s $(which python3) /usr/local/bin/python

# Python
# boto3 installed separatly to avoid infinite pip backtracking
# see https://pip.pypa.io/en/stable/topics/dependency-resolution/#possible-ways-to-reduce-backtracking
RUN pip install "boto3~=1.34"
RUN \
    pip install --upgrade --default-timeout=300 \
        "black[jupyter]~=24.4" \
        "bokeh~=3.2" \
        "bqplot~=0.12" \
        "cookiecutter~=2.1" \
        "cython~=3.0" \
        "dask~=2024.5" \
        "dask-gateway~=2024.1" \
        "dask-jobqueue~=0.7" \
        "dask-labextension~=6.2" \
        "datashader~=0.14" \
        "distributed~=2024.5" \
        "flake8~=7.0" \
        "fsspec~=2024.6" \
        "graphviz~=0.20" \
        "ipympl~=0.9" \
        "ipyspin~=1.0" \
        "ipywidgets~=8.0" \
        "isort~=5.10" \
        "jinja2~=3.1" \
        "jupyterlab-katex~=3.3" \
        "jupyterlab-mathjax3~=4.3" \
        "jupyterlab-spreadsheet-editor~=0.6" \
        "jupyter-resource-usage<1.0.0" \
        "jupyterlab-vega2~=3.2" \
        "jupyterlab-vega3~=3.2" \
        "jupytext~=1.15" \
        # matplotlib >=3.8 have some problemes with docstring import
        "matplotlib~=3.7.3" \
        "nbgitpuller~=1.1" \
        "numba~=0.56" \
        "numexpr~=2.8" \
        "numpy~=1.26" \
        "numpy-stl~=3.1" \
        "packaging~=24.0" \
        "pandas~=2.2" \
        "pandoc~=2.2" \
        "papermill~=2.4" \
        "pipdeptree~=2.2" \
        "plotly~=5.10" \
        "pre-commit~=2.20" \
        # protobuf 4 not compatible with tensorboard
        "protobuf~=3.20" \
        "pylint~=3.2" \
        "pyparsing~=3.0" \
        "pyscaffold~=4.5" \
        "pytest~=8.2" \
        "pytest-tornado~=0.8" \
        "pytest-tornasync~=0.6" \
        "pytest-cov~=5.0" \
        "python-dotenv~=1.0" \
        "pyviz_comms~=3.0" \
        "s3fs~=2024.6" \
        "schema~=0.7" \
        "scikit-image~=0.19" \
        "scipy~=1.9" \
        "seaborn~=0.11" \
        "sidecar~=0.5" \
        "statsmodels~=0.13" \
        "tables~=3.7" \
        "termcolor~=2.4" \
        # spinned for tensorboard white screen error (not compatible with tornado > 6.1,2,3)
        "tornado~=6.4.0" \
        "tox~=4.5" \
        "virtualenv~=20.16" \
        "voila~=0.5" \
        "xarray~=2024.5" \
        && \
    layer-cleanup.sh

# CONDA
# Conda setup system wide
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=$PATH:/opt/miniconda3/bin

# Install extensions and plugins
RUN \
    pip install --no-cache-dir \
        jupyter-launcher-shortcuts~=4.0 \
    && \
    layer-cleanup.sh

# AWS cli
RUN \
    cd /opt && \
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf /opt/aws /opt/awscliv2.zip && \
    pip install --no-cache-dir --quiet awscli-plugin-endpoint && \
    layer-cleanup.sh

# Put startup scripts
COPY resources/jupyter-scripts/* /usr/local/bin/
COPY resources/bash.bashrc /etc/

ENV SHELL /bin/bash

# Put jupyterlab launcher shortcuts config
COPY /resources/jupyterlab_shortcuts /opt/vre/jupyterlab_shortcuts
RUN cat /opt/vre/jupyterlab_shortcuts/config.py >> /usr/local/etc/jupyter/jupyter_notebook_config.py

# Put tests resources
RUN mkdir -p /opt/vre/tests
COPY resources/tests/* /opt/vre/tests/
RUN chmod -R +rX /opt/vre/

EXPOSE 8888
ENTRYPOINT ["start-notebook.sh"]

# Define standard user
RUN adduser --disabled-password --gecos '' vreuser

# Save generated .bashrc, .profile and .bash_logout
RUN mkdir -p /opt/vre/home/ && cp -r /home/vreuser/ /opt/vre/home

USER vreuser
WORKDIR /home/vreuser
