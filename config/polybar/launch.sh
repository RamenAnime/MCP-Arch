#!/usr/bin/env bash
# Launch polybar on all monitors (safe if config missing modules)
set -euo pipefail
dir="${HOME}/.config/polybar"
cfg="${dir}/config.ini"
[ -f "$cfg" ] || exit 0

killall -q polybar 2>/dev/null || true
mapfile -t monitors < <(polybar --list-monitors 2>/dev/null | cut -d: -f1)
if [ "${#monitors[@]}" -eq 0 ]; then
  polybar -q kyoto --config="$cfg" &
else
  for m in "${monitors[@]}"; do
    [ -n "$m" ] || continue
    MONITOR="$m" polybar -q kyoto --config="$cfg" &
  done
fi
wait
