#!/bin/bash

# NOT USED
# #Lenovo ThinkPad Laptop
# edp1=$(xrandr | grep "^eDP-1 connected")
# dp1=$(xrandr | grep "^DP-1 connected")
# dp2=$(xrandr | grep "^DP-2 connected")
# hdmi1=$(xrandr | grep "^HDMI-1 connected")
# hdmi2=$(xrandr | grep "^HDMI-2 connected")

# # Lenovo Docking Station
# dp1-1=$(xrandr | grep "^DP-1-1 connected")
# dp1-2=$(xrandr | grep "^DP-1-2 connected")
# dp1-3=$(xrandr | grep "^DP-1-3 connected")

# VARS
dock="/dev/usb/hiddev0"
dock_xrandr_output="xrandr --output eDP-1 --off --output DP-1-2 --mode 1920x1080 --pos 1080x0 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --mode 1920x1080 --pos 3000x0 --rotate right --output DP-2 --off --output DP-1-1 --mode 1920x1080 --pos 0x0 --rotate left"

lcd_only_xrandr_output="xrandr --output eDP-1 --primary --mode 1600x900 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-1-3 --off --output DP-1-2 --off --output DP-1-1 --off --output HDMI-2 --off"

# Check if USB docking station is connected
if [ -e $dock ]; then
  $dock_xrandr_output
else
  $lcd_only_xrandr_output
fi
