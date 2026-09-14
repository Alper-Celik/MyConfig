#! /bin/sh
firejail --profile=/home/alper/MyConfig/sandbox.profile --whitelist="$PWD" opencode "$@" --auto
