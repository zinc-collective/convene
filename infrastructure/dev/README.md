# Development infrastructure

This directory contains the scaffolding to build and run a local Dockerized
version of the Jitsi server chain. To build and run this Dockerized setup, a
convenience script is provided at [`bin/jitsi-local-run`](../bin/jitsi-local-run).

The "entry point" for this setup is the
[`jitsi-meet.Dorckerfile`](jitsi-meet.Dockerfile), which specifies how to
build a Docker image for a local Jitsi setup. This Dockerfile depends, in
turn, on the shell scripts in this directory.
