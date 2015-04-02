gameserver_root="/home/gmod/serverfiles/garrysmod/"
base_config_file="${gameserver_root}/cfg/gmod-server.cfg"

game_id="gmod"
valve_app_id="4020"

user="gmod"

# Let a mod override some values
. /etc/vz-template/mod_config.sh
