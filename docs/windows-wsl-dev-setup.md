# Development Environment Setup on Windows with WSL2

This document is geared specifically towards an Ubuntu 22.04.1 LTS instance.
All commands given are run from the Linux command line.

## Installing Ruby + Rails

Follow the steps in a guide for Ubuntu, such as [this one (up to step 4)](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04).
Replace the versions in the guide with those given from the [main contributing doc](../CONTRIBUTING.md#2-machine-setup)

## Using Docker with WSL2 (to make use of the `docker-compose.yml`)

### Windows Side

Follow the steps in [this article](https://docs.docker.com/desktop/windows/wsl/) to install Docker Desktop on the Windows side.

### WSL2 Side

On the WSL2 side, install docker with

```bash
sudo apt install docker.io
```

Also uncomment the PostgreSQL-relevant lines in [.env](../.env) (currently lines 12-14).

### Running PostgreSQL server

At this point, in WSL2, you should be able to run `docker compose up`.

## Install `overmind`

Based on [this SE post](https://unix.stackexchange.com/questions/599510/how-to-install-overmind-in-ubuntu)
and the [overmind repo](https://github.com/DarthSim/overmind), run the following, updating the versions if necessary and replacing any placeholders:

```bash
sudo apt-get install tmux # pre-req for overmind
cd ~/downloads # or some other downloads directory
mkdir overmind && cd overmind
wget https://github.com/DarthSim/overmind/releases/download/v2.3.0/overmind-v2.3.0-linux-386.gz # may need to use differnet architecture
wget https://github.com/DarthSim/overmind/releases/download/v2.3.0/overmind-v2.3.0-linux-386.gz.sha256sum

shasum -a 256 overmind-v2.3.0-linux-386.gz | awk '{print $1}' && cat overmind-v2.3.0-linux-386.gz.sha256sum  # Verify these are the same

gunzip -d overmind-v2.3.0-linux-386.gz

# make it executable
sudo chmod +x overmind-v2.3.0-linux-386
mv overmind-v2.2.2-linux-amd64 ~/.local/bin/ # or can mv to /usr/local/bin/ if do sudo

overmind start # verify works
```

## Run convene

Run `bin/run`.

## Accessing convene in the browser

When running the application from WSL2, you cannot access it via `localhost:3000`,
but need to use the IP address of the WSL2 instance.  
To get this address, run the following command (from
[this article](https://hackernoon.com/accessing-network-ppps-running-inside-wsl2-from-other-devices-in-your-lan))
to obtain the IP address of your WSL2 instance:

```bash
ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
```

With this IP address, open `<WSL2 IP address>:3000` in your browser to access the app.

## Running tests

The integration tests (`yarn run test` of the `bin/test` file) currently require a firefox browser to interact with.
We are currently investigating running firefox in a headless mode similar to the GitHub CI ubuntu instance we use.
