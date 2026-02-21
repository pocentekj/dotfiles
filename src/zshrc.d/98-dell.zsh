# Displays (ddcutil --display N)
DELL=2
LENOVO=1

# Common ddcutil wrapper
_ddc() {
  local disp=$1; shift
  ddcutil --sleep-multiplier 2 --display "$disp" "$@" 2>/dev/null
}

_pause() { sleep 0.2 }

# Apply a preset to a display in a readable way.
# Usage: _apply <disp> <mode> <temp_preset> <brightness> <contrast> [R G B]
#   mode: value for VCP DC (display mode). Usually 0x00 for Standard.
#   temp_preset: value for VCP 14 (color preset) e.g. 0x05, 0x08, 0x0b
#   R/G/B are VCP 16/18/1A (only meaningful when temp_preset is User 1/2)
_apply() {
  local disp=$1; shift
  local mode=$1 preset=$2 bri=$3 con=$4
  shift 4

  _ddc $disp setvcp DC $mode
  _ddc $disp setvcp 14 $preset
  _pause

  _ddc $disp setvcp 10 $bri
  _ddc $disp setvcp 12 $con

  # Optional RGB gains
  if (( $# == 3 )); then
    local r=$1 g=$2 b=$3
    _ddc $disp setvcp 16 $r
    _ddc $disp setvcp 18 $g
    _ddc $disp setvcp 1A $b
  fi
}

# ---------------- DELL P3225QE (Display 2) ----------------

dell_daily() {
  _apply $DELL 0x00 0x08 65 70
}

dell_evening() {
  _apply $DELL 0x00 0x05 55 55
}

dell_night() {
  # User 1 unlocks RGB
  _apply $DELL 0x00 0x0b 52 65 52 50 47
}

# ---------------- LENOVO N27q (Display 1) ----------------

lenovo_daily() {
  _apply $LENOVO 0x00 0x05 60 70
}

lenovo_evening() {
  _apply $LENOVO 0x00 0x05 45 60
}

lenovo_night() {
  # Warm it up: more R, less B
  _apply $LENOVO 0x00 0x0b 35 45 54 50 44
}

# ---------------- Whole desk macros ----------------

work_daily()   { dell_daily;   lenovo_daily }
work_evening() { dell_evening; lenovo_evening }
work_night()   { dell_night;   lenovo_night }
