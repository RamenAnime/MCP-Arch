#!/bin/bash
# Screen lock (works without custom wallpaper)
if command -v i3lock-color >/dev/null 2>&1; then
  i3lock-color --screen 1 --timepos 50%x:60% --datepos 50%x:70% \
    --clock --timestr "%H:%M:%S" --datestr "%Y-%m-%d" \
    --ringwidth 4 --insidecolor 00110000 --ringcolor 0aff0aff \
    --linecolor 00000000 --keyhlcolor 00ff00ff --bshlcolor 00ff00ff \
    --separatorcolor 00000000 --insidevercolor 00110000 --insidewrongcolor 00110000 \
    --ringvercolor 0aff0aff --ringwrongcolor ff0000ff
elif command -v i3lock >/dev/null 2>&1; then
  i3lock -c 001100
else
  echo "No i3lock installed"
fi
