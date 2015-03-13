fullname=$1

sed -i "s/^hostname .*/hostname \"$fullname\"/" /home/css/serverfiles/cstrike/cfg/css-server.cfg
