#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/add_sm_admins << 'EOF'
#!/bin/bash
# /etc/init.d/add_sm_admins
# Script to run on the first boot of the template.
# Wgets a file containing steam admins and applies their role to sourcemod.

# format is "STEAM_0:1:16"		"99:z"

start() {
    # Get game server root
    . /etc/vz-template/template_vars.sh

    steam_ids_dir=$(mktemp -d "/tmp/XXXXXXXXXXXX")
    steam_ids_file="$steam_ids_dir/ids.txt"
    wget https://raw.githubusercontent.com/lanmomo/server-keys/master/build/steam_ids -O "$steam_ids_file"

    admin_config="$gameserver_root/addons/sourcemod/configs/admins_simple.ini"

    while read line;
    do
        echo "\"$line\"     \"99:z\"" >> "$admin_config"
    done < "$steam_ids_file"

    update-rc.d -f add_sm_admins remove
    rm -f /etc/init.d/add_sm_admins

    exit 0
}

case "$1" in
    start)
        start
        ;;
esac

EOF

update-rc.d -f add_sm_admins remove
chmod +x /etc/init.d/add_sm_admins
update-rc.d add_sm_admins defaults 19
