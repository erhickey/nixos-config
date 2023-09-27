#!/usr/bin/env bash

mail_dir="$HOME/.mail/[Gmail]"
new=0

for d in "$mail_dir"/*/new ; do
  new="$(("$new" + "$(find "$d" -type f | wc -l)"))"
done

[ "$new" -gt 0 ] && echo "" || echo ""
