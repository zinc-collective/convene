#!/bin/bash

echo "See files in '.devcontainer/output' for errors and other info"

if ! [ -d /workspaces ]; then
    echo "Not in CodeSpace! Exiting startup.bash ..."
    exit 1
fi
set -x # for printing commands

# persist data by actually storing in /workspaces directory
# NOTE: This will not persist across codespace creations, just starts/stops
function database_workspace_setup {
    real_location=$1
    if [ -z ${real_location} ]; then
        echo "Did not supply correct args to $0 !"
        exit 1
    fi
    if [ ! -e ${real_location} ]; then
        mkdir -p ${real_location}/_data
        false
    else
        true
    fi
}

function database_symlink_setup {
    real_location=$1
    symlink_location=$2
    if [ -z ${real_location} ] || [ -z ${symlink_location} ]; then
        echo "Did not supply correct args to $0 !"
        exit 1
    fi

    if [ -z $(sudo readlink ${symlink_location}) ]; then # workaround to check if symlink (permissions issues?)
        if [ -e ${symlink_location} ]; then
            sudo rm -rf ${symlink_location}
        fi
        sudo ln -s ${real_location} ${symlink_location}
        if [ $? != 0 ]; then
            echo "Cannot create symlink of ${real_location}"; exit 1
        fi
    fi
}
pg_real=/workspaces/postgresql
redis_real=/workspaces/redis
pg_old=/var/lib/docker/volumes/convene_postgres_data
redis_old=/var/lib/docker/volumes/convene_redis_data

data_files_existed=0

database_workspace_setup ${pg_real}
if [ $? != 0 ]; then data_files_existed=1; fi
# sudo chown -R 999:999 ${pg_real}

database_workspace_setup ${redis_real}
if [ $? != 0 ]; then data_files_existed=1; fi
sudo chown -R 999:999 ${redis_real}

database_symlink_setup ${pg_real} ${pg_old}
database_symlink_setup ${redis_real} ${redis_old}

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

if [ ${data_files_existed} != 0 ]; then
    setup_out='.devcontainer/output/bin_setup.out'
    time $( bin/setup &> $setup_out ) >> $setup_out # output time to file, too
fi

rm -f .overmind.sock
bin/run &> .devcontainer/output/bin_run.out &
# echo "Now you can run 'bin/run' on the command line!"
# echo "Then the app should be running soon!"

set +x # stop printing commands

echo "The app should be running soon!"
echo "To access the app in your browser:"
echo "  - Go to 'Ports' tab of the terminal pane"
echo "  - Wait for Port 3000 to show up in left-hand column"
echo "  - Click on the globe 🌐 (Open in Browser) under 'Local Address"
echo "    next to the entry for Port 3000."
