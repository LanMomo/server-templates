#!/bin/bash

password=$1

. /etc/vz-template/template_vars.sh

sed -i "s/^AdminPassword=.*/AdminPassword=${password}/" "$base_config_file"
