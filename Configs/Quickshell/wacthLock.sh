#!/bin/sh
stdbuf -i0 -o0 -e0 dbus-monitor --system --profile "interface=org.freedesktop.login1.Session" | stdbuf -i0 -o0 -e0 grep -E "Unlock|Lock" --only-matching | tee log.txt
