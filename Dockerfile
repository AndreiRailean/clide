ARG BASE_IMAGE=ruby:latest
FROM ${BASE_IMAGE}

# Ensure we are root for installations
USER root

# Define build-time arguments with defaults
ARG USER_ID=1000
ARG GROUP_ID=1000

# Install system dependencies and tools
RUN apt-get update && apt-get install -y \
    tmux \
    neovim \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create a group and user matching the host IDs
RUN if getent group $GROUP_ID; then \
      # If GID exists, find its name and use it for the user
      EXISTING_GROUP=$(getent group $GROUP_ID | cut -d: -f1); \
      useradd -m -u $USER_ID -g $EXISTING_GROUP -s /bin/bash devuser; \
    else \
      # If GID doesn't exist, create a new group and the user
      groupadd -g $GROUP_ID devgroup && \
      useradd -m -u $USER_ID -g devgroup -s /bin/bash devuser; \
    fi

# Create config directories
RUN mkdir -p /home/devuser/.local/share/nvim \
             /home/devuser/.local/state/nvim \
             /home/devuser/.config/nvim

# Use numeric IDs for COPY to avoid name conflicts
# COPY local configs into the image
COPY --chown=${USER_ID}:${GROUP_ID} configs/.tmux.conf /home/devuser/.tmux.conf
COPY --chown=${USER_ID}:${GROUP_ID} configs/init.lua /home/devuser/.config/nvim/init.lua
COPY --chown=${USER_ID}:${GROUP_ID} configs/.bash_aliases /home/devuser/.bash_aliases

# Use numeric IDs for the recursive chown
RUN chown -R ${USER_ID}:${GROUP_ID} /home/devuser

# Add app dir to path so scripts and binaries in root folder are available globally
RUN echo "PATH=/app:$PATH" >> /home/devuser/.bashrc

# Copy the start script
COPY --chown=${USER_ID}:${GROUP_ID} configs/tmux-start.sh /usr/local/bin/tmux-start

# Make it executable
RUN chmod +x /usr/local/bin/tmux-start

# Set the working directory inside the container and change ownership
WORKDIR /app

# Switch to the non-root user
USER devuser

# Set the default command to run when the container starts
# This launches a shell session with tmux
CMD ["tmux", "new-session", "-s", "dev"]

