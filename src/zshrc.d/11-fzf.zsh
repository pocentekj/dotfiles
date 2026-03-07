# SEARCH
# -----------------------------------------------------------------------------
# NOTE: requires `fzf`, `bat`, and `fd`

for cmd in fzf bat fd; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "11-fzf.zsh [WARNING]: $cmd not found" >&2
    return
  fi
done

# Search with live preview
alias fzp="fzf --multi --preview 'bat --color always {}'"

# Run program on search results, e.g. 'fzr mpv'
fzr() {
  [ $# -gt 0 ] || { echo "Usage: fzr <cmd> [args...]"; return 2; }
  local file
  file=$(fzf) || return 1
  setsid "$@" "$file" </dev/null >/dev/null 2>&1 &
}

# Edit search results in Neovim
fze() {
  local file
  file=$(
    fd -t f -H --follow \
      -E .steam -E .git -E node_modules -E dist -E build -E target \
      -E '*.png' -E '*.jpg' -E '*.jpeg' -E '*.gif' -E '*.webp' \
      -E '*.pdf' -E '*.zip' -E '*.tar' -E '*.gz' -E '*.xz' -E '*.7z' \
      -E '*.mp3' -E '*.flac' -E '*.wav' -E '*.mp4' -E '*.mkv' \
      . \
    | fzf --preview 'bat --color=always -- {}'
  ) || return 1
  nvim -- "$file"
}

# Search for markdown files with live preview (requires glow)
fzmd() {
  local file
  file=$(fd -e md | fzf --preview 'glow -- {}') || return 1
  nvim -- "$file"
}

fzmpv() {
  local file
  file=$(
    fd -t f \
      -e mp4 -e mkv -e webm -e mov -e m4v \
      -e avi -e mpg -e mpeg -e flv -e ogv \
      . \
    | fzf
  ) || return 1
  setsid mpv "$file" </dev/null >/dev/null 2>&1 &
}

fzpdf() {
 local file
 file=$(fd -e pdf | fzf) || return 1
 setsid evince "$file" </dev/null >/dev/null 2>&1 &
}
