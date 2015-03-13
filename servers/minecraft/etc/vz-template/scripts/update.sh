#!/bin/bash

# Download latest version from minecraft.net
VER=`curl -s https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
wget https://s3.amazonaws.com/Minecraft.Download/versions/$VER/minecraft_server.$VER.jar -O /home/minecraft/server/minecraft_server.jar
chown minecraft /home/minecraft/server/minecraft_server.jar
