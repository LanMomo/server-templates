#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
HOST_BRIDGE="vmbr0"
DNS="8.8.8.8"

ct_exists() {
    local id="$1"
    [ $(vzlist -1a | tr -d ' ' | grep "^${id}$") ]
}

pop_vm() {
    line="$1"
    hostname=$(echo "$line" | cut -f 1 -d ';')
    vzconfig=$(echo "$line" | cut -f 2 -d ';')
    ostemplate_short=$(echo "$line" | cut -f 3 -d ';')
    public_mac=$(echo "$line" | cut -f 5 -d ';')
    ctid=$(echo "$line" | cut -f 6 -d ';')

    # Get template path from host vz.conf
    . /etc/vz/vz.conf
    template_path="$TEMPLATE/cache/"
    ostemplate_long=$(ls "$template_path" | grep -i "^$ostemplate_short" | sort -rfg | head -n 1 | | sed s/\.tar\.*//g)

    # Create ct and set network
    vzctl create "$ctid" --ostemplate "$ostemplate_long" --name "$hostname" --hostname "$hostname" --config "$vzconfig"
    vzctl set "$ctid" --netif_add "eth0,${public_mac},veth${ctid}.0,,${HOST_BRIDGE}" --save
    vzctl set "$ctid" --nameserver "$DNS" --save

    # Create network interface for DHCP
    ct_private=$(vzlist -a1o private "$ctid")
    interfaces="${ct_private}/etc/network/interfaces"

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
    if [[ $(tr -dc ';' <<<"$line" | wc -c) -eq 5 ]] && ! ct_exists "$ctid"; then
        pop_vm "$line"
    fi
done < "${DIR}/vms.csv"
