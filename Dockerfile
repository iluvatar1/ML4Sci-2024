# See docs : https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html
FROM python:3.11-slim
    MAINTAINER William Oquendo <wfoquendop@unal.edu.co>
#ARG CACHEBUST=0 # reset cache at this point, change to 1 to reset cache

USER root

# Install packages
#RUN apt-get update
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc libffi-dev\
    g++ \
    make \
    cmake \
    clang \
    libeigen3-dev \
    bat \
    emacs-nox \
    vim \
    gnuplot-nox \
    nano \
    git \
    htop \
    curl \
    unzip \
    sudo \
    cpplint \
    zsh \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install the notebook package
RUN pip install --upgrade pip && \
    pip install notebook jupyterlab

# Copy only the requirements file first
COPY requirements.txt .

# Install extra Python packages
RUN python3 -m pip install -r requirements.txt

# Install starship to show git branch in prompt plus some other stuff
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Fix timezone
ENV TZ=America/Bogota
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set the shell to zsh
ENV SHELL=/bin/zsh
RUN chsh -s /bin/zsh
## Set the SHELL environment variable to /bin/bash
#ENV SHELL=/bin/bash

# create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --shell /bin/bash \
    --uid ${NB_UID} \
    ${NB_USER}

# Copy the rest of the files
COPY . ${HOME}

# Set ownership of files
USER root
RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}
USER ${USER}

# Run matplotlib config to generate the font cache
RUN MPLBACKEND=Agg python3 -c "import matplotlib.pyplot"
# Setup starship
RUN echo 'eval "$(starship init bash)"' >> ${HOME}/.bashrc

# Clone the lectures repo
#RUN git clone REPO

# Install jupyterlab extensions
COPY postBuild /tmp/postBuild
RUN /tmp/postBuild

# Configure zsh
# Install Zim
RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
# Configure starship
RUN echo 'eval "$(starship init zsh)"' >> ${HOME}/.zshrc

# Start Zsh when the container runs
CMD [ "zsh" ]
