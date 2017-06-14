#!/usr/bin/env bash

# This code is mostly due to Adam Bowen's superuser answer:
# https://superuser.com/questions/603528/how-to-get-the-current-monitor-resolution-or-monitor-name-lvds-vga1-etc/992924#992924

# Regular expression to find the offset
OFFSET_RE="\+([-0-9]+)\+([-0-9]+)"

# Get the window position
pos=($(xwininfo -id $(xdotool getactivewindow) | 
  sed -nr "s/^.*geometry .*$OFFSET_RE.*$/\1 \2/p"))

# Loop through each screen and compare the offset with the window
# coordinates.
while read name width height xoff yoff
do
  if [[ "${pos[0]}" -ge "$xoff" \
     && "${pos[1]}" -ge "$yoff" \
     && "${pos[0]}" -lt "$(($xoff+$width))" \
     && "${pos[1]}" -lt "$(($yoff+$height))" ]]
  then
    monitor=$name   
    wmonitor=$width
    hmonitor=$height
    xmonitor=$xoff
    ymonitor=$yoff
  fi
done < <(xrandr | grep -w connected |
  sed -r "s/^([^ ]*).*\b([-0-9]+)x([-0-9]+)$OFFSET_RE.*$/\1 \2 \3 \4 \5/" |
  sort -nk4,5)

# If we found a monitor, echo its width, height and offsets
# Otherwise exit with an error code
if [ ! -z "$monitor" ]
then
  echo "$wmonitor $hmonitor $xmonitor $ymonitor"
  exit 0
fi
exit 1

