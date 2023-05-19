#!/bin/sh
# keybindings
setxkbmap -option caps:escape

# screen
case $HOSTNAME in
  (lenovo-ideapad-510) xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1 --primary --mode 1440x900 --pos 1920x0 --rotate normal --output HDMI-2 --off # TODO: handle unplugged
esac
