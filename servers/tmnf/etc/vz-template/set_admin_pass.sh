#!/bin/bash

password=$1

sed -i "s/<password>.*<\/password>/<password>${password}<\/password>/" "/home/tmnf/serverfiles/GameData/Config/dedicated_cfg.txt"
sed -i "s/<password>.*<\/password>/<password>${password}<\/password>/" "/home/tmnf/serverfiles/config.xml"
