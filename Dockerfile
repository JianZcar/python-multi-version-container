FROM fedora:latest

LABEL maintainer="esteban.jianzcar@outlook.com"

WORKDIR /workspace

RUN dnf update -y && dnf install -y \
    @development-tools \
    openssl-devel \
    zlib-devel \
    bzip2-devel \
    readline-devel \
    sqlite-devel \
    llvm \
    ncurses-devel \
    xz \
    tk-devel \
    libffi-devel \
    lzma-sdk \
    wl-clipboard \
    wayland-devel \
    && dnf clean all

# Install pyenv
ENV PYENV_ROOT="/root/.pyenv" \
    PATH="/root/.pyenv/bin:/root/.pyenv/shims:/root/.pyenv/versions:$PATH"

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && $PYENV_ROOT/plugins/python-build/install.sh \
    && echo 'eval "$(pyenv init --path)"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Install multiple Python versions
RUN pyenv install 3.9 \
    && pyenv install 3.10 \
    && pyenv install 3.11 \
    && pyenv install 3.12 \
    && pyenv install 3.13 \
    && pyenv global 3.9 3.10 3.11 3.12 3.13 \
    && pyenv rehash

# Verify installation
RUN pyenv versions

RUN dnf update -y && dnf install -y helix && dnf clean all

ENV TERM="xterm-256color" \
    COLORTERM="truecolor"

# Enable true color support
RUN echo "export PS1='\[\033[38;5;39m\]\u@\h \[\033[38;5;208m\]\w\[\033[0m\] $ '" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc 

# Set the default command
CMD ["bash", "-i"]
