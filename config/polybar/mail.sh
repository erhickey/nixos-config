#!/usr/bin/env bash

mail_dir="$HOME/.mail/[Gmail]"
new=0

if [ -d "$mail_dir" ] ; then
  for d in "$mail_dir"/*/new ; do
    new="$(("$new" + "$(find "$d" -type f | wc -l)"))"
  done
fi

[ "$new" -gt 0 ] && echo "" || echo ""
