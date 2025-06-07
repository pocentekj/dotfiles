#!/bin/bash
if ip link | grep -q "proton"; then
  echo '{"text":"󰌆","class":"vpn-active","tooltip":"VPN active"}'
fi

