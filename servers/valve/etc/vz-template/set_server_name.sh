fullname=$1

# load base_config_file
. /etc/vz-template/template_vars.sh

sed -i "s/^hostname .*/hostname \"$fullname\"/" "$base_config_file"
