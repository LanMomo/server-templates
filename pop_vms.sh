#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
HOST_BRIDGE="vmbr0"
DNS="8.8.8.8"

ct_exists() {
    local id="$1"
    [ $(vzlist -1a | tr -d ' ' | grep "^${id}$") ]
}

pop_vm() {
    local line="$1"
    local hostname=$(echo "$line" | cut -f 1 -d ';')
    local vzconfig=$(echo "$line" | cut -f 2 -d ';')
    local ostemplate_short=$(echo "$line" | cut -f 4 -d ';')
    local public_mac=$(echo "$line" | cut -f 6 -d ';')
    local ctid=$(echo "$line" | cut -f 7 -d ';')

    # Get template path from host vz.conf
    . /etc/vz/vz.conf
    local template_path="$TEMPLATE/cache/"
    local ostemplate_long=$(ls "$template_path" | grep -i "^$ostemplate_short" | sort -rfg | head -n 1 | sed s/\.tar\.*//g)

    # Create ct and set network
    vzctl create "$ctid" --ostemplate "$ostemplate_long" --name "$hostname" --hostname "$hostname" --config "$vzconfig"

    if ! ct_exists "$ctid"; then
        echo "FAILED TO CREATE CT $ctid"
        exit 1
    fi

    vzctl set "$ctid" --netif_add "eth0,${public_mac},veth${ctid}.0,,${HOST_BRIDGE}" --save
    vzctl set "$ctid" --nameserver "$DNS" --save

    # Create network interface for DHCP
    local ct_private=$(vzlist -a1o private "$ctid")

    local interfaces="${ct_private}/etc/network/interfaces"

    cat > "$interfaces" << EOF
# Auto generated lo interface
auto lo
iface lo inet loopback

# Interface for DHCP
auto eth0
    iface eth0 inet dhcp
EOF
}


# Sync vz configs
bash $DIR/utils/sync_configs.sh

csv_file="${DIR}/vms.csv"
if [ "$#" -eq 1 ]; then
    csv_file="$1"
fi

while read line; do
    ctid=$(echo "$line" | cut -f 7 -d ';')
    overlay=$(echo "$line" | cut -f 3 -d ';')
    if [[ $(tr -dc ';' <<<"$line" | wc -c) -eq 6 ]] && ! ct_exists "$ctid"; then
        # Build CT from vz template
        pop_vm "$line"
        # (re)Inject overlay
        bash "${DIR}/inject.sh" "$ctid" "$overlay"
    fi
done < "$csv_file"
