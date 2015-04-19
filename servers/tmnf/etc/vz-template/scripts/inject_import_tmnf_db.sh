#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/import_tmnf_db << 'EOF'
#!/bin/bash
# /etc/init.d/import_tmnf_db
# Script to run on the first boot of the template.
# Calls import_tmnf_db.sh and deletes itself

start() {
    bash /etc/vz-template/import_tmnf_db.sh
}

case "$1" in
    start)
        start
        ;;
esac

EOF

update-rc.d -f import_tmnf_db remove
chmod +x /etc/init.d/import_tmnf_db
update-rc.d import_tmnf_db defaults 19
