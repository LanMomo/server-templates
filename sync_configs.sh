#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
rsync -v "${DIR}/vz_configs/" "/etc/vz/conf/"
