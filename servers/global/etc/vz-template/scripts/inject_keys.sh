#!/bin/bash
# Script to inject a one time boot script.
# Should be run each time inside in the container before converting to template.

    cat > /etc/init.d/inject_keys << 'EOF'
#!/bin/bash
# /etc/init.d/inject_keys
# Download ssh keys from a gist and injects them to root

start() {
    if [[ ! -d /root/.ssh/ ]]; then
        mkdir /root/.ssh/
    else
        rm -f /root/.ssh/authorized_keys
    fi

    wget https://raw.githubusercontent.com/lanmomo/server-keys/master/build/authorized_keys -O /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/
    chmod 600 /root/.ssh/authorized_keys

    if [[ ! -d "$user_home/.ssh/" ]]; then
        mkdir "$user_home/.ssh/"
    else
        rm -f "$user_home/.ssh/authorized_keys"
    fi

    user=$(cat /etc/passwd | grep 1000 | cut -d ':' -f 1 | head -n 1)
    if [ -z "$user" ]; then
        exit 1
    fi
    user_home=$(cat /etc/passwd | grep 1000 | cut -d ':' -f 6 | head -n 1)

    cp /root/.ssh/authorized_keys "$user_home/.ssh/authorized_keys"
    chmod 700 "$user_home/.ssh/"
    chmod 600 "$user_home/.ssh/authorized_keys"
    chown -R "${user}:" "$user_home/.ssh/"

    exit 0
}

case "$1" in
    start)
        start
        ;;
esac

EOF

update-rc.d -f inject_keys remove
chmod +x /etc/init.d/inject_keys
update-rc.d inject_keys defaults
