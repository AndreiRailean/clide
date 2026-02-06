ARG BASE_IMAGE=ruby:4
FROM "${BASE_IMAGE}"
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Ensure we are root for installations
USER root

# Define build-time arguments with defaults
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install system dependencies and tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    tmux \
    neovim \
    git \
    curl \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a group and user matching the host IDs
RUN if getent group $GROUP_ID; then \
      # If GID exists, find its name and use it for the user
      EXISTING_GROUP=$(getent group $GROUP_ID | cut -d: -f1); \
      useradd --no-log-init -m -u $USER_ID -g "$EXISTING_GROUP" -s /bin/bash devuser; \
    else \
      # If GID doesn't exist, create a new group and the user
      groupadd -g $GROUP_ID devgroup && \
      useradd --no-log-init -m -u $USER_ID -g devgroup -s /bin/bash devuser; \
    fi

RUN usermod -aG sudo devuser && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Create config directories
RUN mkdir -p /home/devuser/.local/share/nvim \
             /home/devuser/.local/state/nvim \
             /home/devuser/.config/nvim

# Use numeric IDs for COPY to avoid name conflicts
# COPY local configs into the image
COPY --chown=${USER_ID}:${GROUP_ID} configs/.tmux.conf /home/devuser/.tmux.conf
COPY --chown=${USER_ID}:${GROUP_ID} configs/init.lua /home/devuser/.config/nvim/init.lua
COPY --chown=${USER_ID}:${GROUP_ID} configs/.bash_aliases /home/devuser/.bash_aliases
COPY --chown=${USER_ID}:${GROUP_ID} configs/tmux-start.sh /usr/local/bin/tmux-start

RUN chown -R ${USER_ID}:${GROUP_ID} /home/devuser && \
    echo "PATH=/app:$PATH" >> /home/devuser/.bashrc && \
    chmod +x /usr/local/bin/tmux-start

# Set the working directory inside the container and change ownership
WORKDIR /app

# Switch to the non-root user
USER devuser

# Set the default command to run when the container starts
# This launches a shell session with tmux
CMD ["tmux", "new-session", "-s", "dev"]

