#! /usr/bin/env bash
set -e

main_file=/etc/nginx/conf.d/default.conf

export PORT?${PORT:-80}

for var in $(env | awk -F "=" '{print $1}'); do
    value=$(eval "echo \$$var")
    sed -i "s@\${$var}@\"$value\"@g" $main_file
done

exec nginx -g "daemon off;"