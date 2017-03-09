#!/bin/sh

# size of the bars around your screen:
# top, bottom, left, right
STOP=0
SBOT=0
SLFT=30
SRGT=0
# size of the top+bottom borders of your windows
# (useful only for (up/low)(left/right))
SBRD=18

set_on_top()
{
  wmctrl -r :ACTIVE: -b add,above
}

unset_on_top()
{
  wmctrl -r :ACTIVE: -b remove,above
}

W=`xdpyinfo | awk '/dimensions:/ {print $2}' | cut -f1 -d'x'`
H=`xdpyinfo | grep dimensions | sed 's/.*dimensions[^x]*x\([^ ]*\).*$/\1/'`

# default width and heighth given the available info
DWDT=$(($W-$SLFT-$SRGT))
DHGT=$(($H-$STOP-$SBOT-$SBRD))

if [ "$1" = "lowleft" -o "$1" = "upleft" -o "$1" = "left" -o "$1" = "lowright" -o "$1" = "upright" -o "$1" = "center" ]; then
  wmctrl -r :ACTIVE: -b remove,maximized_horz
  wmctrl -r :ACTIVE: -b remove,maximized_vert
  wmctrl -r :ACTIVE: -b remove,fullscreen
fi

# put active window on the lower left corner
if [ "$1" = "lowleft" ]; then
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  TOP=$(($HGT+$STOP+$SBRD))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$SLFT,$TOP,$WDT,$HGT
fi

# put active window on the upper left corner
if [ "$1" = "upleft" ]; then
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$SLFT,$STOP,$WDT,$HGT
fi

# put active window on left side
if [ "$1" = "left" ]; then
  WDT=$(($DWDT/2))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$SLFT,$STOP,$WDT,$DHGT
fi

# put active window on the lower right corner
if [ "$1" = "lowright" ]; then
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  LFT=$(($WDT+$SLFT))
  TOP=$(($HGT+$STOP+$SBRD))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$TOP,$WDT,$HGT
fi

# put active window on the upper right corner
if [ "$1" = "upright" ]; then
  WDT=$(($DWDT/2))
  HGT=$((($DHGT-$SBRD)/2))
  LFT=$(($WDT+$SLFT))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$STOP,$WDT,$HGT
fi

# put active window on right side
if [ "$1" = "right" ]; then
  WDT=$(($DWDT/2))
  LFT=$(($WDT+$SLFT))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$STOP,$WDT,$DHGT
fi

# put active window at the bottom of the screen (good for terminals)
if [ "$1" = "down" ]; then
  H=$(($DHGT/4))
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,$SLFT,$(($DHGT-$H)),$DWDT,$H
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,$SLFT,$(($DHGT-$H)),$DWDT,$H
  set_on_top
fi

# put active window at the center of the screen
if [ "$1" = "center" ]; then
  DH=$(($DHGT/8))
  DW=$(($DWDT/8))
  PADL=$(($SLFT+$DW))
  PADT=$(($TOP+$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($DWDT-2*$DW)),$(($DHGT-2*$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($DWDT-2*$DW)),$(($DHGT-2*$DH))
  unset_on_top
fi

# toggle "window always on top"
if [ "$1" = "atop" ]; then
  wmctrl -r :ACTIVE: -b toggle,above
fi

# put active window in fullscreen mode
if [ "$1" = "fullscreen" ]; then
  wmctrl -r :ACTIVE: -b toggle,fullscreen
fi

if [ "$1" = "switchto" ]; then
  wmctrl -r :ACTIVE: -t $2
fi
