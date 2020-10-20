#!/bin/bash

# Description: bash script to test connected monitors on Lenovo laptop and set xrandr display parameters according

# xrandr display parameters
dock_3_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1-1 --mode 1920x1080 --pos 0x0 --rotate left --output DP-1-2 --mode 1920x1080 --pos 1080x0 --rotate normal --output DP-1-3 --mode 1920x1080 --pos 3000x0 --rotate right --output HDMI-1 --off --output HDMI-2 --off --output DP-1 --off --output DP-2 --off"

dock_2_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1-1 --off --output DP-1-2 --mode 1920x1080 --pos 1080x0 --rotate normal --output DP-1-3 --mode 1920x1080 --pos 3000x0 --rotate right --output HDMI-1 --off --output HDMI-2 --off --output DP-1 --off --output DP-2 --off"

hdmi_extended_up_xrandr_output="xrandr --output eDP-1 --primary --mode 1600x900 --pos 119x1080 --rotate normal --output DP-1 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal"

lcd_only_xrandr_output="xrandr --output eDP-1 --primary --mode 1600x900 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-1-3 --off --output DP-1-2 --off --output DP-1-1 --off --output HDMI-2 --off"

# --------------------------

# pull in current data from xrandr
# TESTING ONLY: xrandr_data=$(cat display_test_dock.txt)

xrandr_data=$(xrandr)
# echo "DEBUG: ${xrandr_data}"

# test xrandr data variable for connected displays and set accordingly
case $xrandr_data in
  *"DP-1-1 connected"*"DP-1-2 connected"*"DP-1-3 connected"*)
    dock=connected:3_displays
    $dock_3_displays_xrandr_output
    ;;
  *"DP-1-1 disconnected"*"DP-1-2 connected"*"DP-1-3 connected"*)
    dock=connected:2_displays
    $dock_2_displays_xrandr_output
    ;;
  *"HDMI-2 connected"*)
    hdmi_port=connected
    $hdmi_extended_up_xrandr_output
    ;;
  *)
    dock=disconnected
    hdmi_port=disconnected
    $lcd_only_xrandr_output
    ;;
esac

# some human readable output prior to exit
echo "USB-C Dock is $dock"
echo "HDMI Port is $hdmi_port"

# END SCRIPT
# --------------------------

# unused commands
# dock="/dev/usb/hiddev0" # old test for dock connected as usb device file with line: if [ -e $dock ]; then
