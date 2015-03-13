fullname=$1

sed -i "s/^hostname .*/hostname \"$fullname\"/" /home/tf2/serverfiles/tf/cfg/tf2-server.cfg
