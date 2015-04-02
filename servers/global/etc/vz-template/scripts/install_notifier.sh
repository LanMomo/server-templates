#!/bin/bash
# Download, install and add to boot the lanmomo-notifier deamon when templating

# pre inst
if ! grep -q '^lanmomo-notifier:' /etc/passwd ; then
    useradd -r lanmomo-notifier
fi

apt-get -y --force-yes install python3 python3-requests

mkdir /opt/lanmomo-notifier/



# inst
wget https://raw.githubusercontent.com/lanmomo/gameserver-notifier/master/src/notifier.py -O /opt/lanmomo-notifier/notifier.py
chmod 700 /opt/lanmomo-notifier/notifier.py
chown lanmomo-notifier /opt/lanmomo-notifier/notifier.py


# post inst
cat > /etc/init.d/lanmomo-notifier << 'EOF'
#!/bin/bash
# /etc/init.d/lanmomo-notifier

#Settings
NOTIFIER_PATH='/opt/lanmomo-notifier/'
SERVICE='lanmomo-notifier'
USER='lanmomo-notifier'
SCREENSESSION="lanmomo-notifier"
HISTORY=1024

# load token and url
. /etc/vz-template/notifier_config_global.sh

# load game_id
. /etc/vz-template/template_vars.sh


start_service() {
    su - $USER -c "cd '$NOTIFIER_PATH'; screen -h '$HISTORY' -dmS '$SCREENSESSION' python3 notifier.py --token '$token' --url '$url' --interval 30 '$game_id'"
}

stop_service() {
    su - $USER -c "screen -p 0 -S $SCREENSESSION -X quit"
}

#Start-Stop here
case "$1" in
    start)
        start_service
    ;;
    stop)
        stop_service
    ;;
    restart)
        stop_service
        start_service
    ;;
    status)
       if su - c $USER "screen -ls | grep -q $SCREENSESSION"; then
           echo "$SERVICE is running."
       else
           echo "$SERVICE is not running."
       fi
    ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
    ;;
esac

exit 0

EOF

update-rc.d -f lanmomo-notifier remove
chmod +x /etc/init.d/lanmomo-notifier
update-rc.d lanmomo-notifier defaults
