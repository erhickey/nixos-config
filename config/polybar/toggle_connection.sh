#!/usr/bin/env bash

connection_id="$1"

if [ "$(nmcli con show --active "$connection_id" | wc -l)" -eq 0 ] ; then
  nmcli con up id "$connection_id"
else
  nmcli con down id "$connection_id"
fi
