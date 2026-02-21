# Dell P3225QE = Display 2
DELL_DISP=2

# --sleep-multiplier = slower, less retries
_ddc() {
  ddcutil --sleep-multiplier 2 --display "$DELL_DISP" "$@" 2>/dev/null
}

_pause() { sleep 0.2; }

dell_daily() {
  _ddc setvcp DC 0x00
  _ddc setvcp 14 0x08 # 9300 K
  _pause
  _ddc setvcp 10 65   # brightness
  _ddc setvcp 12 70   # contrast
}

dell_evening() {
  _ddc setvcp DC 0x00
  _ddc setvcp 14 0x05 # 6500 K
  _pause
  _ddc setvcp 10 55   # brightness
  _ddc setvcp 12 55   # contrast
}

dell_night() {
  _ddc setvcp DC 0x00
  _ddc setvcp 14 0x0b # User presets - unlocks RGB
  _pause
  _ddc setvcp 10 52   # brightness
  _ddc setvcp 12 65   # contrast
  _ddc setvcp 16 52   # R
  _ddc setvcp 18 50   # G
  _ddc setvcp 1A 47   # B
}
