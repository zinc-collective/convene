#!/bin/bash
set -x # for printing commands

echo "See files in '.devcontainer/output' for errors and other info"

if ! [ -d /workspaces ]; then
    echo "Not in CodeSpace! Exiting startup.bash ..."
    exit 1
fi

# persist data by actually storing in /workspaces directory
# NOTE: This will not persist across codespace creations, just starts/stops
postgres_data=/var/lib/postgresql/data
redis_data=/bitnami/redis/data
if ! [ -L ${postgres_data} ] || ! [ -e ${postgres_data} ]; then
    mkdir -p /workspaces/postgresql
    ln -s /workspaces/postgresql/data ${postgres_data}
fi

if ! [ -L ${redis_data} ] || ! [ -e ${redis_data} ]; then
    mkdir -p /workspaces/redis
    ln -s /workspaces/redis/data ${redis_data}
fi

# If postgres and redis aren't both running, start them up again and wait till running, otherwise, continue
if [ "`docker inspect -f {{.State.Running}} convene-db-1`" != "true" ] || \
   [ "`docker inspect -f {{.State.Running}} convene-redis-1`" != "true" ]; then
    echo "Startup containers"
    docker compose up &> .devcontainer/output/docker_compose_up.out &
    until [ "`docker inspect -f {{.State.Running}} convene-db-1`" == "true" ] && \
        [ "`docker inspect -f {{.State.Running}} convene-redis-1`" == "true" ]; do
        sleep 1;
    done;
fi


# TODO: Add timing to docker-compose up above block and bin/setup block below; report to respective files
# TODO: Add wait to bin/run section to grep output file for trigger that is finished setting up?

Xvfb $DISPLAY -ac &> .devcontainer/output/Xvfb.out &

if [ ! -f .env ]; then
    cp .env.example .env
    sed -i "/^# PG/s/^# //g" .env
fi
echo "Run 'bin/setup'"
setup_out='.devcontainer/output/bin_setup.out'
time $( bin/setup &> $setup_out ) >> $setup_out # output time to file, too

rm -f .overmind.sock
echo "Run 'bin/run'"
bin/run &> .devcontainer/output/bin_run.out &
# echo "Now you can run 'bin/run' on the command line!"
# echo "Then the app should be running soon!"

echo "The app should be running soon!"
echo "To access the app in your browser:"
echo "  - Go to 'Ports' tab of the terminal pane"
echo "  - Wait for Port 3000 to show up in left-hand column"
echo "  - Click on the globe 🌐 (Open in Browser) under 'Local Address"
echo "    next to the entry for Port 3000."
