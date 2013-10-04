#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
setxkbmap pl
#exec xcompmgr -f -o 0.1 -r 3 -l 1 -t 1 -c&
xcompmgr -c -C -t-5 -l-5 -r4.2 -o.99&
exec remuco-mpd &
exec awsetbg ~/.background &
exec awesome
#exec fluxbox
