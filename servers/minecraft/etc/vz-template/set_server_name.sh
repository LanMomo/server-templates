fullname=$1

sed -i "s/^motd=.*/motd=$fullname/" /home/minecraft/server/server.properties
