#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

cat > /etc/init.d/inject_keys << 'EOF'
#!/bin/bash
# /etc/init.d/inject_keys
# Download ssh keys from a gist and injects them to root

if [[ ! -d /root/.ssh/ ]]; then
    mkdir /root/.ssh/
else
    rm -f /root/.ssh/authorized_keys
fi

wget https://raw.githubusercontent.com/lanmomo/server-keys/master/build/authorized_keys -O /root/.ssh/authorized_keys

chmod 700 /root/.ssh/
chmod 600 /root/.ssh/authorized_keys

update-rc.d -f inject_keys remove
rm -f /etc/init.d/inject_keys

EOF

update-rc.d -f inject_keys remove
chmod +x /etc/init.d/inject_keys
update-rc.d inject_keys defaults
