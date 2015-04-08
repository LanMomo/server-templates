#!/bin/bash
rsync -rv "$(dirname "$(readlink -f "$0")")/../vz_configs/" "/etc/vz/conf/"
