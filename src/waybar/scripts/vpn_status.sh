#!/bin/bash

iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^proton-[a-z]{2}(-[0-9]+)?$' | head -n1)

if [[ -n "$iface" ]]; then
  country=$(echo "$iface" | sed -E 's/^proton-([a-z]{2}).*/\1/')
  country_code=$(echo "$country" | tr '[:lower:]' '[:upper:]')
  echo "{\"text\":\"<span font='18' foreground='#cdd6f4'>󰌆</span> $country_code\",\"class\":\"vpn-active\",\"tooltip\":\"VPN active ($country_code)\"}"
fi
