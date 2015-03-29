#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/inject_keys << 'EOF'
#!/bin/bash
# /etc/init.d/inject_keys
# Download ssh keys from a gist and injects them to root

rm -f /root/.ssh/authorized_keys
wget https://gist.githubusercontent.com/jdupl/2e433770121013d5f76d/raw/keys -O /root/.ssh/authorized_keys

chmod 700 /root/.ssh/
chmod 600 /root/.ssh/authorized_keys

update-rc.d -f inject_keys remove
rm -f /etc/init.d/inject_keys

EOF

update-rc.d -f inject_keys remove
chmod +x /etc/init.d/inject_keys
update-rc.d inject_keys defaults
