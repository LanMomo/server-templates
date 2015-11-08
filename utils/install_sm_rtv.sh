#!/bin/bash -e
# Installs metamod and sourcemod and enables rtv plugin.

# TODO move this to sourcemod and get gameserver path from template

wget http://cdn.probablyaserver.com/sourcemod/mmsource-1.10.6-linux.tar.gz -O mmsource.tar.gz
tar -zxf mmsource.tar.gz
rm mmsource.tar.gz

wget http://www.sourcemod.net/smdrop/1.7/sourcemod-1.7.3-git5273-linux.tar.gz -O sourcemod.tar.gz
tar -zxf sourcemod.tar.gz
rm sourcemod.tar.gz

mv addons/sourcemod/plugins/disabled/{mapchooser.smx,rockthevote.smx} addons/sourcemod/plugins/
