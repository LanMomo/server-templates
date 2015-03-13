fullname=$1

sed -i "s/^hostname .*/hostname \"$fullname\"/" /home/csgo/serverfiles/csgo/cfg/csgo-server.cfg
