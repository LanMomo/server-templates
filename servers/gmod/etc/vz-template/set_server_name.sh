fullname=$1

sed -i "s/^hostname .*/hostname \"$fullname\"/" /home/gmod/serverfiles/garrysmod/cfg/gmod-server.cfg
