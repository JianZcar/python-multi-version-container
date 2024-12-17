FROM ubuntu:latest

LABEL maintainer="esteban.jianzcar@outlook.com"

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git \
    wl-clipboard \
    wayland-protocols \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    && rm -rf /var/lib/apt/lists/*

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
    && pyenv global 3.9 3.10 3.11 3.12 3.13

# Verify installation
RUN pyenv versions

#Install Latest Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && ls /opt \
    && echo 'export PATH="/opt/nvim-linux64/bin:$PATH"' >> /root/.bashrc \
    && rm nvim-linux64.tar.gz

# Enable true color support
RUN echo "export PS1='\[\033[38;5;39m\]\u@\h \[\033[38;5;208m\]\w\[\033[0m\] $ '" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "export TERM=xterm-256color" >> /root/.bashrc \
    && echo "export COLORTERM=truecolor" >> /root/.bashrc


# Set the default command
CMD ["bash", "-i"]
