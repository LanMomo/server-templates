#!/bin/bash -e
# Installs metamod and sourcemod and enables rtv plugin.

# TODO move this to sourcemod and get gameserver path from template

wget http://mirror.pointysoftware.net/alliedmodders/mmsource-1.10.4-linux.tar.gz -O mmsource.tar.gz
tar -zxf mmsource.tar.gz
rm mmsource.tar.gz

wget http://mirror.pointysoftware.net/alliedmodders/sourcemod-1.7.0-linux.tar.gz -O sourcemod.tar.gz
tar -zxf sourcemod.tar.gz
rm sourcemod.tar.gz

mv addons/sourcemod/plugins/disabled/{mapchooser.smx,rockthevote.smx} addons/sourcemod/plugins/
