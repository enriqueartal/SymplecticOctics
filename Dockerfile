# Dockerfile for binder
# Reference: https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html

FROM ghcr.io/sagemath/sage-binder-env:10.2

USER root

# Create user alice with uid 1000
ARG NB_USER=alice
ARG NB_UID=1000
ENV NB_USER alice
ENV NB_UID 1000
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password --gecos "Default user" --uid ${NB_UID} ${NB_USER}

# Make sure the contents are in ${HOME}
COPY CheckCurveInvolution.ipynb ${HOME}/
RUN mkdir -p $(HOME)/files2
COPY files2/* ${HOME}/files2/
RUN chown -R ${NB_USER}:${NB_USER} ${HOME}

# Install Sage package
# RUN /sage/sage -i <spkg-name>

# Switch to the user
USER ${NB_USER}

# Install Sage kernel to Jupyter
RUN mkdir -p $(jupyter --data-dir)/kernels
RUN ln -s /sage/venv/share/jupyter/kernels/sagemath $(jupyter --data-dir)/kernels

# Start in the home directory of the user
WORKDIR /home/${NB_USER}