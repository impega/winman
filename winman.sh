#!/bin/sh

# user input size of the bars around your screen:
# top, bottom, left, right
USTOP=0
USBOT=0
USLFT=30
USRGT=0
# size of the top+bottom borders of your windows
# (useful only for (up/low)(left/right))
USBRD=18

set_on_top()
{
  wmctrl -r :ACTIVE: -b add,above
}

unset_on_top()
{
  wmctrl -r :ACTIVE: -b remove,above
}

WH=`winman_getsize.sh`
W=`echo $WH | cut -d " " -f 1`
H=`echo $WH | cut -d " " -f 2`
X=`echo $WH | cut -d " " -f 3`
Y=`echo $WH | cut -d " " -f 4`

# full and half width and heighth given the available info
FWDT=$(($W-$USLFT-$USRGT))
FHGT=$(($H-$USTOP-$USBOT-$USBRD))
HWDT=$((FWDT/2))
HHGT=$((FHGT/2))

SBRD=$USBRD

# important points on the window: intersections of
# top, middle and bottom
# left, center and right

LFT=$(($USLFT+$X))
XMD=$(($LFT+$HWDT))
RGT=$(($X+$W-$USRGT))

TOP=$(($USTOP+$Y))
YMD=$(($TOP+$SBRD+$HHGT))
BOT=$(($Y+$H-$USBOT))

if [ "$1" = "lowleft" -o "$1" = "upleft" -o "$1" = "left" -o "$1" = "lowright" -o "$1" = "upright" -o "$1" = "center" ]; then
  wmctrl -r :ACTIVE: -b remove,maximized_horz
  wmctrl -r :ACTIVE: -b remove,maximized_vert
  wmctrl -r :ACTIVE: -b remove,fullscreen
fi

# put active window on the lower left corner
if [ "$1" = "lowleft" ]; then
  HGT=$(($HHGT-$SBRD))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$YMD,$HWDT,$HGT
fi

# put active window on the upper left corner
if [ "$1" = "upleft" ]; then
  HGT=$(($HHGT-$SBRD))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$TOP,$HWDT,$HGT
fi

# put active window on left side
if [ "$1" = "left" ]; then
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$LFT,$TOP,$HWDT,$FHGT
fi

# put active window on the lower right corner
if [ "$1" = "lowright" ]; then
  HGT=$((($FHGT-$SBRD)/2))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$XMD,$YMD,$HWDT,$HGT
fi

# put active window on the upper right corner
if [ "$1" = "upright" ]; then
  HGT=$((($FHGT-$SBRD)/2))
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$XMD,$TOP,$HWDT,$HGT
fi

# put active window on right side
if [ "$1" = "right" ]; then
  unset_on_top
  wmctrl -r :ACTIVE: -e 0,$XMD,$TOP,$HWDT,$FHGT
fi

# put active window at the bottom of the screen (good for terminals)
if [ "$1" = "down" ]; then
  H=$(($HHGT/4))
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,$LFT,$(($FHGT-$H)),$FWDT,$H
  wmctrl -r :ACTIVE: -b add,maximized_horz
  wmctrl -r :ACTIVE: -e 0,$LFT,$(($FHGT-$H)),$FWDT,$H
  set_on_top
fi

# put active window at the center of the screen
if [ "$1" = "center" ]; then
  DH=$(($FHGT/8))
  DW=$(($FWDT/8))
  PADL=$(($LFT+$DW))
  PADT=$(($TOP+$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($FWDT-2*$DW)),$(($FHGT-2*$DH))
  wmctrl -r :ACTIVE: -e 0,$PADL,$PADT,$(($FWDT-2*$DW)),$(($FHGT-2*$DH))
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
