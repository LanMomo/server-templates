#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/auto_hostname << 'EOF'
#!/bin/bash
# /etc/init.d/auto_hostname
# Script to run on the first boot of the template.
# Calls set_server_name if executable and removes itself.

if [[ -x /etc/vz-template/set_server_name.sh ]]; then
    base_name="LAN Montmorency $(date +%Y)"
    hostname=$(hostname | cut -d '.' -f 1)

    /etc/vz-template/set_server_name.sh "${base_name} - ${hostname}"
else
    echo "Warning: Ignoring auto game server name integration from hostname !"
fi

update-rc.d -f auto_hostname remove
rm -f /etc/init.d/auto_hostname

EOF

update-rc.d -f auto_hostname remove
chmod +x /etc/init.d/auto_hostname
update-rc.d auto_hostname defaults 19
