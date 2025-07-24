#!/bin/bash
# List mounted volumes in /media/$(whoami)
sep='  '
mounts=$(mount | grep "/media/$(whoami)/" | awk '{print $3}' | awk -F'/' '{print $NF}' | awk -v s=" $sep " 'NR==1{printf "%s", $1} NR>1{printf "%s%s", s, $1} END{print ""}')
if [ -n "$mounts" ]; then
  text=" $sep $mounts"   #  is the Font Awesome drive icon, can swap for another
else
  text=""
fi
echo "{\"text\": \"🖴 $text\", \"tooltip\": \"Mounted volumes in /media/$(whoami)/\"}"

