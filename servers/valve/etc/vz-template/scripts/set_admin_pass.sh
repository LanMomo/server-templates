#!/bin/bash

password=$1

. /etc/vz-template/template_vars.sh

sed -i "s/^rcon_password.*/rcon_password ${password}/" "$base_config_file"
