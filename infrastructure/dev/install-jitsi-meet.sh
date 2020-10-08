#!/bin/bash

set -e

# Script assumes it is running as root
#
# Jitsi installation steps were cobbled together from:
# - Jitsi self-hosting docs: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart
# - forum tips about how to silently install jitsi-meet: https://community.jitsi.org/t/silent-installation/55519
# To see how we install Jitsi in production, see the install script in this repo: infrastructure/videobridge/install

# To Build docker image:
# $ docker build -f jitsi-meet.Dockerfile .
# Docker run command with published ports:
# $ docker run -it -p 80:80 -p 443:443 -p 8080:8080 --hostname jitsi
# Verify you have a running videobridge:
# $ curl localhost:8080/about/version

apt-get update && apt-get install -y curl gpg debconf-utils nginx
curl https://download.jitsi.org/jitsi-key.gpg.key | sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null

HOSTNAME="jitsi"
cat << EOF | debconf-set-selections
jicofo	jitsi-videobridge/jvb-hostname	string	$HOSTNAME
jitsi-meet-prosody	jitsi-meet-prosody/jvb-hostname	string $HOSTNAME
jitsi-meet-prosody	jitsi-videobridge/jvb-hostname	string	$HOSTNAME
jitsi-meet-turnserver	jitsi-videobridge/jvb-hostname	string	$HOSTNAME
jitsi-meet-web-config	jitsi-videobridge/jvb-hostname	string	$HOSTNAME
jitsi-videobridge2	jitsi-videobridge/jvb-hostname	string	$HOSTNAME
jitsi-meet jitsi-meet/cert-choice select Generate a new self-signed certificate
EOF

debconf-get-selections | grep jitsi

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y jitsi-meet

# for service in jicofo jitsi-videobridge2 prosody nginx ; do service $service start ; done
