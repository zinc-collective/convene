#!/bin/bash

# This script assumes it is running as root, and is meant for use as entrypoint in a Docker container.

set -e

# Make sure all the jitsi-related services are running
# In the case that existing .pid files are found, 'restart' works more reliably than using 'start'.
for service in jicofo jitsi-videobridge2 prosody nginx ; do service $service restart ; done

# Cheesy way to prevent this script from ever exiting.
#
# This is needed because the various jitsi servers are being as background
# services, and Docker wants and entrypoint that doesn't exit (when the
# entrypoint exits, the container will stop).
#
# Would be nice to polish this, but since it is for development debugging, it
# might not be worth the investment.
sleep infinity
