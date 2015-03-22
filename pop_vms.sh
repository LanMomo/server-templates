#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
HOST_BRIDGE="vmbr0"
VZ_ROOT="/var/lib/vz/private"

ct_exists() {
    local id="$1"
    [ $(vzlist -1a | tr -d ' ' | grep "^${id}$") ]
}

pop_vm() {
    line="$1"
    hostname=$(echo "$line" | cut -f 1 -d ';')
    ctid=$(echo "$line" | cut -f 2 -d ';')
    ostemplate=$(echo "$line" | cut -f 3 -d ';')
    public_mac=$(echo "$line" | cut -f 5 -d ';')
    private_mac=$(echo "$line" | cut -f 6 -d ';')
    vzconfig=$(echo "$line" | cut -f 7 -d ';')

    vzctl create "$ctid" --ostemplate "$ostemplate" --name "$hostname" --hostname "$hostname" --config "$vzconfig"

    vzctl set "$ctid" --netif_add "eth0,${public_mac},veth${ctid}.0,,${HOST_BRIDGE}" --save

    interfaces="${VZ_ROOT}/${ctid}/etc/network/interfaces"
    cat > $interfaces << EOF
# Auto generated lo interface
auto lo
iface lo inet loopback

# Interface for DHCP
auto eth0
    iface eth0 inet dhcp
EOF
}

while read line;
do
    ctid=$(echo "$line" | cut -f 2 -d ';')
    if [[ $(tr -dc ';' <<<"$line" | wc -c) -eq 6 ]] && ! ct_exists "$ctid"; then
        pop_vm "$line"
    fi
done < "${DIR}/vms.csv"
