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
