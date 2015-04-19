#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/auto_admin << 'EOF'
#!/bin/bash
# /etc/init.d/auto_admin
# Script to run on the first boot of the template.
# Calls set_admin_pass and removes itself.

start() {
    if [[ -f /etc/vz-template/set_admin_pass.sh ]]; then
        # Generate an easy to type password
        pass=$(< /dev/urandom tr -dc a-z0-9 | head -c6;echo;)
        bash /etc/vz-template/set_admin_pass.sh "$pass"
        echo "$pass" > /root/admin_pass.txt
        chmod 400 /root/admin_pass.txt

        update-rc.d -f auto_admin remove
        rm -f /etc/init.d/auto_admin

        exit 0
    else
        echo "Warning: Ignoring auto admin password integration !"
        exit 1
    fi
}

case "$1" in
    start)
        start
        ;;
esac

EOF

update-rc.d -f auto_admin remove
chmod +x /etc/init.d/auto_admin
update-rc.d auto_admin defaults 19
