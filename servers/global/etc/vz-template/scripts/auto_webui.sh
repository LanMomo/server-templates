#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/auto_webui << 'EOF'
#!/bin/bash
# /etc/init.d/auto_webui
# Script to run on the first boot of the template.
# Calls set_webui_pass and removes itself.

if [[ -f /etc/vz-template/set_webui_pass.sh ]]; then
    pass=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c16;echo;)
    bash /etc/vz-template/set_webui_pass.sh "$pass"
    echo "$pass" > /root/webui_pass.txt
    chmod 400 /root/webui_pass.txt
else
    echo "Warning: Ignoring auto webui admin integration !"
fi

update-rc.d -f auto_webui remove
rm -f /etc/init.d/auto_webui

EOF

update-rc.d -f auto_webui remove
chmod +x /etc/init.d/auto_webui
update-rc.d auto_webui defaults
