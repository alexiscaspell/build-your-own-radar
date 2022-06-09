#! /usr/bin/env bash
set -e

export PAGE_HOST="${PAGE_HOST:-0.0.0.0}"
export PAGE_PORT="${PAGE_PORT:-1338}"

main_file=$(ls -f /opt/build-your-own-radar/main*.js|head -n 1)

for var in $(env | awk -F "=" '{print $1}'); do
    value=$(eval "echo \$$var")
    sed -i "s@e.env.$var@\"$value\"@g" $main_file
done

# If there's a prestart.sh script in the /app directory, run it before starting
PRE_START_PATH=/app/prestart.sh
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . $PRE_START_PATH
else
    echo "There is no script $PRE_START_PATH"
fi

# Start Supervisor, with Nginx and uWSGI
exec /usr/bin/supervisord