#!/bin/bash

. /etc/vz-template/template_vars.sh

su - "$user" -c "/home/${user}/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/${user}/serverfiles +app_update $valve_app_id -validate +quit"
