#!/usr/bin/env bash
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

workdir="$HOME/Downloads/Walpapers"
cd "$workdir"
walpaper=$(fd 2.\* -e jpg -a | shuf | head -n 1)

cfg() {
  jq "$1" "$walpaper.json" -r
}

qs ipc call walpaper set "$walpaper" "$(cfg .title?)" "$(cfg .description?)" "$(cfg .copyright?)"
