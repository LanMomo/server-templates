fullname=$1

# load base_config_file
. /etc/vz-template/template_vars.sh

short_name=$(hostname | cut -d '.' -f 1)

sed -i "s/^ServerName=.*/ServerName=${fullname}/" "$base_config_file"
sed -i "s/^ShortName=.*/ShortName=${short_name}/" "$base_config_file"
