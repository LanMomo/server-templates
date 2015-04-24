#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"

ct_exists() {
    local id="$1"
    [ $(vzlist -1a | tr -d ' ' | grep "^${id}$") ]
}


for ct in {100100..100200}; do
    if ct_exists "$ct"; then
	    ct_private=$($vzlist "$ct" -H -o root)
        notifier_file="${ct_private}/etc/vz-template/notifier_config_global.sh"
        if [[ -f "$notifier_file" ]]; then
        	cat "${DIR}/../servers/notifier/etc/vz-template/notifier_config_global.sh" > "$notifier_file"
        fi
    fi
done
