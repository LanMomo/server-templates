#!/bin/bash

# Script to sync files from servers folder to container.

DIR="$(dirname "$(readlink -f "$0")")"

if [ "$#" -ne 2 ]; then
    echo "READ THE CODE"
    exit 1
fi

ctid=$1
server_template=$2

ct_private=$(vzlist -a1o private "$ctid")

sync() {
    template_sync=$1

    source_dir="${DIR}/servers/${template_sync}/"
    dest_dir="${ct_private}/"

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
    local template="$1"

    inject_requirements "$template"
    sync "$template"
}

inject_requirements() {
    local template=$1
    local requirement=$(cat "${DIR}/requirements.txt" | grep "^$template:" | cut -d ':' -f 2 | head -n 1)

    if [[ -n "$requirement" ]]; then
        install "$requirement"
    fi
}

# Remove any old content in /etc/vz-template
rm -rf "${ct_private}/etc/vz-template/"

# Sync generic file to container
sync "global"

# Sync template with nested dependencies
install "$server_template"
