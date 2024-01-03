# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    expect \
    unzip \
    file \
    && rm -rf /var/lib/apt/lists/*

# Install NVM
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.10.0

RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Add nvm.sh to bashrc for future login sessions
RUN echo "export NVM_DIR=$NVM_DIR" >> ~/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

# Load NVM and install Node.js
RUN . $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION

# Set up the environment for Node.js
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Download and set up the Sentry Node CLI
RUN curl -L -o sentry-node-cli-linux.zip "https://github.com/xai-foundation/sentry/releases/latest/download/sentry-node-cli-linux.zip"
RUN unzip sentry-node-cli-linux.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/sentry-node-cli-linux

# Clean up
RUN rm sentry-node-cli-linux.zip

# Copy the start-up and liveness scripts into the image
COPY ./startup.sh /usr/local/bin/startup.sh
COPY ./liveness.sh /usr/local/bin/liveness.sh
RUN chmod +x /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/liveness.sh

# Run the start.sh script when the container starts
CMD ["/usr/local/bin/startup.sh"]
