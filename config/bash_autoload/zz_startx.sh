#!/usr/bin/env bash

if [ -z "$DISPLAY" ] && [ "$(fgconsole 2> /dev/null || printf "0")" -eq 1 ] ; then
  startx
fi
