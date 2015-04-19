#!/bin/bash

sqlfile=$(mktemp)

wget https://gist.githubusercontent.com/pgrenaud/54eda51683938f6b3255/raw/tmnf.sql -O "$sqlfile"

mysql < "$sqlfile"

rm "$sqlfile"
