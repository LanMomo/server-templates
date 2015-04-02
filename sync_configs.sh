#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
rsync -rv "${DIR}/vz_configs/" "/etc/vz/conf/"
