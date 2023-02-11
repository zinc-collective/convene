#!/bin/bash

echo "See files in '.devcontainer/output' for errors and other info"

echo "Startup containers"
docker compose up &> .devcontainer/output/docker_compose_up.out &

sleep 20

if [ ! -f .env ]; then 
    cp .env.example .env 
    sed -i "/^# PG/s/^# //g" .env 
fi 
echo "Run 'bin/setup'"
if bin/setup &> .devcontainer/output/bin_setup.out ; then
    echo "'bin/setup' failed; sleeping for 20s then trying again"
    sleep 20
    if bin/setup &> .devcontainer/output/bin_setup.out ; then
        echo "Could not complete 'bin/setup'!"
        exit 1
    fi
fi

rm -f .overmind.sock 
echo "Run 'bin/run'"
bin/run &> .devcontainer/output/bin_run.out &

echo "App should be running soon!"
echo "To access the app in your browser:"
echo "  - Go to 'Ports' tab of the terminal pane"
echo "  - Wait for Port 3000 to show up in left-hand column"
echo "  - Click on the globe 🌐 (Open in Browser) under 'Local Address"
echo "    next to the entry for Port 3000."
