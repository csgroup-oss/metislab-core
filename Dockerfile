# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

# Based on the Pangeo docker images logic (https://github.com/pangeo-data/pangeo-docker-images)
# (CNES fork: https://github.com/CNES/datalabs-docker-images).
# base-image uses ONBUILD instructions to install, from files of this repository:
#   apt.txt, jupyter_notebook_config.py, environment.yml, requirements.txt,
#   resources/*/install.sh and start
ARG BASE_IMAGE_TAG=e0c6dfd
FROM cnes/base-image:${BASE_IMAGE_TAG}
LABEL maintainer="CS GROUP"

ENV PATH=/opt/code-server/bin:${PATH}
ENV VSCODE_EXTENSIONS=/opt/code-server/extensions

# Remove the build context copied in the home directory by base-image
USER root
RUN cd ${HOME} && \
    rm -rf Dockerfile apt.txt environment.yml jupyter_notebook_config.py requirements.txt resources start
USER ${NB_USER}

CMD ["jupyter", "lab", "--ip=0.0.0.0"]
