#!/usr/bin/env bash

connection_id="$1"

if [ "$(nmcli con show --active "$connection_id" | wc -l)" -eq 0 ] ; then
  echo "󰌙"
else
  echo "󰌘"
fi
