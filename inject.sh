#!/bin/bash

# Script to sync files from servers folder to container.

DIR="$(dirname "$(readlink -f "$0")")"
VZ_ROOT="/var/lib/vz/"

if [ "$#" -ne 2 ]; then
    echo "READ THE CODE"
    exit 1
fi

ctid=$1
server_template=$2

sync() {
    template_sync=$1

    source_dir="${DIR}/servers/${template_sync}/"
    dest_dir="${VZ_ROOT}/private/${ctid}/"

    echo "Syncing ${template_sync} from '${source_dir}' to '${dest_dir}'."

    if [[ ! -d "$source_dir" ]]; then
        echo "Directory '${source_dir}' not found !"
        exit 1
    fi

    if [[ ! -d "$dest_dir" ]]; then
        echo "Directory '${dest_dir}' not found !"
        exit 1
    fi

    rsync -rv "$source_dir" "$dest_dir"
    echo "Done syncing '${template_sync}'"
}

install() {
    template=$1
    requirement=$(cat "${DIR}/requirements.txt" | grep "\:$template$")

    IFS=':' read -a array <<< "$requirement"
    for element in "${array[@]}"
    do
        sync "$element"
    done
}


# Sync generic file to container
sync "global"

# Sync template with nested dependencies
install "$server_template"
