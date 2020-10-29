# Local Infrastructure <!-- omit in toc -->

- [Running Jitsi Meet locally](#running-jitsi-meet-locally)
- [Debugging your local Jitsi](#debugging-your-local-jitsi)
- [Docker configuration](#docker-configuration)

This directory provides a Dockerized configuration for running Jitsi
locally, for when you need to work on Jitsi configuration or debugging.

## Running Jitsi Meet locally

You will need a running Docker engine. See the official Docker documentation
for instructions for your specific platform: https://docs.docker.com/engine/install/

To build and run a local container with Jitsi, run (from repo root):
```
$ bin/jitsi-local-run
```

This configuration uses a self-signed certificate, so when accessing your local
https://jitsi you will need to bypass your browser's security warnings. (You
might need to use Firefox for this to work, Chrome seems to have tightened
their settings to a point where you can't bypass this warning.)

The services running in the container are fronted by an Nginx instance that relies on the
hostname in order to route you to the correct service, so you will need to always access
the local services via the hostname `jitsi`, and not just the Docker IP address. For this
to work, you will need to add the your Docker IP as hostname `jitsi` to you `/etc/hosts` file.

## Debugging your local Jitsi

You can interact with your local Jitsi Meet by starting a shell within the container:
```
$ docker exec -it jitsi-meet-local bash
```

You are now root within the Jitsi Meet container. Here you can:
* Access Jitsi's configuration files in `/etc/jitsi/*`
* See the videobridge logs: `more /var/log/jitsi/jvb.log`
* Query the videobridge's debug endpoint: `curl localhost:8080/debug`

For more docs on debugging Jitsi's videobridge, see https://github.com/jitsi/jitsi-videobridge/blob/master/doc/debugging.md

## Docker configuration

The "entry point" for this Docker configuration is the
[`jitsi-meet.Dockerfile`](jitsi-meet.Dockerfile), which specifies how to
build a Docker image for a local Jitsi setup. This Dockerfile depends, in
turn, on the shell scripts in this directory.
