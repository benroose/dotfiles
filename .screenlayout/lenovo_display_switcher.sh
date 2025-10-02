#!/bin/bash

# Description: bash script to test connected monitors on Lenovo laptop and set xrandr display parameters according

# xrandr display parameters
dock_2_displays_xrandr_output_1="xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-1-1 --mode 3440x1440 --pos 0x0 --rotate normal --output DP-1-2 --off --output DP-1-3 --mode 1440x900 --pos 3440x0 --rotate right"
dock_2_displays_xrandr_output_2="xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-1-1 --off --output DP-1-2 --primary --mode 3440x1440 --pos 0x0 --rotate normal --output DP-1-3 --mode 1440x900 --pos 3440x0 --rotate right"
#HORIZONTAL dock_3_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-1-1 --mode 1920x1080 --pos 0x360 --rotate normal --output DP-1-2 --mode 1920x1080 --pos 1920x360 --rotate normal --output DP-1-3 --mode 1440x900 --pos 3840x0 --rotate right"
dock_3_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-1-1 --mode 1920x1080 --pos 0x0 --rotate left --output DP-1-2 --mode 1920x1080 --pos 1080x840 --rotate normal --output DP-1-3 --mode 1440x900 --pos 3000x480 --rotate right"
#OLD dock_3_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1-1 --mode 1920x1080 --pos 0x0 --rotate left --output DP-1-2 --mode 1920x1080 --pos 1080x0 --rotate normal --output DP-1-3 --mode 1280x1024 --pos 3000x0 --rotate right --output HDMI-1 --off --output HDMI-2 --off --output DP-1 --off --output DP-2 --off"

#dock_2_displays_xrandr_output="xrandr --output eDP-1 --off --output DP-1-1 --off --output DP-1-2 --mode 1920x1080 --pos 1080x0 --rotate normal --output DP-1-3 --mode 1920x1080 --pos 3000x0 --rotate right --output HDMI-1 --off --output HDMI-2 --off --output DP-1 --off --output DP-2 --off"

hdmi_sidekick_monitor_xrandr_output="xrandr --output eDP-1 --primary --mode 1600x900 --pos 0x380 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --mode 1280x720 --pos 1600x0 --rotate left --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off"
#hdmi_extended_up_xrandr_output="xrandr --output eDP-1 --primary --mode 1600x900 --pos 119x1080 --rotate normal --output DP-1 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal"

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
    # check if input-leap (was barrier) is running
    if pgrep -x "input-leapc" >/dev/null; then
      echo "input-leap client is already running"
    else
      echo "starting input-leap client to connect with Intel NUC"
      input-leapc -n lenovo-laptop 192.168.10.41 &
    fi
    ;;
  *"DP-1-1 connected"*"DP-1-2 disconnected"*"DP-1-3 connected"*)
    dock=connected:2_displays
    $dock_2_displays_xrandr_output_1
    # check if input-leap (was barrier) is running
    if pgrep -x "input-leapc" >/dev/null; then
      echo "input-leap client is already running"
    else
      echo "starting input-leap client to connect with Intel NUC"
      input-leapc -n lenovo-laptop 192.168.10.41 &
    fi
    ;;
  *"DP-1-1 disconnected"*"DP-1-2 connected"*"DP-1-3 connected"*)
    dock=connected:2_displays
    $dock_2_displays_xrandr_output_2
    # check if input-leap (was barrier) is running
    if pgrep -x "input-leapc" >/dev/null; then
      echo "input-leap client is already running"
    else
      echo "starting input-leap client to connect with Intel NUC"
      input-leapc -n lenovo-laptop 192.168.10.41 &
    fi
    ;;
  *"HDMI-2 connected"*)
    hdmi_port=connected
    $hdmi_sidekick_monitor_xrandr_output
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
