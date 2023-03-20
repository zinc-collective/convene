FROM mcr.microsoft.com/devcontainers/ruby:3.1

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install additional gems.
# RUN gem install <your-gem-names-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

## Installing overmind and other packages
RUN su vscode -c "sudo wget https://github.com/DarthSim/overmind/releases/download/v2.3.0/overmind-v2.3.0-linux-386.gz && \
                    sudo gunzip -d overmind-v2.3.0-linux-386.gz && \
                    sudo mkdir -p ~/.local/bin && \
                    sudo mv overmind-v2.3.0-linux-386 ~/.local/bin/overmind && \
                    sudo chmod +x ~/.local/bin/overmind && \
                    sudo apt update && \
                    sudo apt install -y tmux graphviz firefox-esr xvfb" 2>&1
RUN bundle install; bin/setup; exit 0
