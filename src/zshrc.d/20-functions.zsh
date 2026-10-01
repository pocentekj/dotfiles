mkscript() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkscript <filename>"
    return 1
  fi

  local filename

  filename="$(pwd)/$1"

  if [[ -e "$filename" ]]; then
    echo "ERROR: file exists"
    return 1
  fi

  echo '#!/usr/bin/env bash' > "$filename" && chmod +x "$filename"

  echo "Created $filename"
}

fdbytime() {
  local search_path="${1:-$PWD}"

  fd \
    . \
    --hidden \
    --extension mkv \
    --extension webm \
    --max-depth 1 \
    --print0 \
    -- "$search_path" |
  xargs \
    --null \
    --no-run-if-empty \
    stat --printf='%Y\t%n\n' |
  sort --numeric-sort |
  cut --fields=2-
}

fdbyrtime() {
  local search_path="${1:-$PWD}"

  fd \
    . \
    --hidden \
    --extension mkv \
    --extension webm \
    --max-depth 1 \
    --print0 \
    -- "$search_path" |
  xargs \
    --null \
    --no-run-if-empty \
    stat --printf='%Y\t%n\n' |
  sort --numeric-sort --reverse |
  cut --fields=2-
}

# `qp` -> "Quick Ping"
qp() {
  if [[ -z "$1" ]]; then
    echo "Usage: qp <hostname>"
    return 1
  fi

  ping -qc1 "$1" | tail -n1 | cut -d'=' -f2 | cut -d'/' -f3
}

cdu() {
  setopt localoptions pipefail
  du --human-readable --total "${1:-$PWD}" | tail -n1 | cut -f1
}
