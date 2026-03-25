#!/usr/bin/env bash
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Configuration
info_url="https://bing.npanuhin.me/ROW-en.$(date +%Y).json"
workdir="$HOME/Downloads/Walpapers"
info_json="$workdir/info_current.json"

mkdir -p "$workdir"

curl --fail --location --connect-timeout 10 --output "$info_json" "$info_url"
last_index=$(jq "length - 1" "$info_json")
random_index=$(($RANDOM % $last_index))
filename=$(jq ".[$random_index].url" "$info_json" -r | sed "s/.*\///")

jq ".[$random_index]" "$info_json" >"$workdir/$filename.json"
curl --fail --location --connect-timeout 30 --output "$workdir/$filename" "$(jq ".[$random_index].url" "$info_json" -r)"

cfg() {
  jq "$1" "$workdir/$filename.json" -r
}

qs ipc call walpaper set "$workdir/$filename" "$(cfg .title?)" "$(cfg .description?)" "$(cfg .copyright?)"
