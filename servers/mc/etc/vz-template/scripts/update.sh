#!/bin/bash

# Download latest version from minecraft.net if version.txt differs

VERSION_FILE="/home/minecraft/server/version.txt"
JAR_FILE="/home/minecraft/server/minecraft_server.jar"

current_version=`curl -s https://s3.amazonaws.com/Minecraft.Download/versions/versions.json | jsawk -n 'out(this.latest.release)'`
installed_version=0

if [[ -f "$VERSION_FILE" ]]; then
    installed_version=$(cat "$VERSION_FILE")
fi

if [[ "$installed_version" != "$current_version" ]]; then
    echo "Updating minecraft server from ${installed_version} to ${current_version}..."
    wget "https://s3.amazonaws.com/Minecraft.Download/versions/$current_version/minecraft_server.$current_version.jar" -O "$JAR_FILE"
    chown minecraft "$JAR_FILE"
    echo "$current_version" > "$VERSION_FILE"
    echo "Done updating minecraft server."
fi

chown minecraft: /home/minecraft/server/server.properties
