#!/usr/bin/env bash

function import_vpn() {
  nmcli connection import type openvpn file "$1"

  # activate connection:
  # sudo nmcli con up id CONNECTION_ID
  #
  # show connection info (inactive connections display -- under DEVICE):
  # nmcli con
}

function pre_commit_hook() {
  cat <<- 'EOF'
		#!/usr/bin/env bash
		set -eo pipefail
		npx prettier --check $(git diff main --name-only --diff-filter=d -- '*.ts' '*.html')
		node node_mdules/eslint/bin/eslint.js $(git diff main --name-only --diff-filter=d -- '*.ts')
	EOF
}

function userdotbazelrc() {
  cat <<- 'EOF'
		build --config=dev --define debug=true
	EOF
}

function angularls() {
  echo 'npm install -g @angular/language-server@14'
}

export DATABASE_URL=postgresql://rivet@localhost
alias sql='vi "$HOME"/tmp/rivet.sql'
