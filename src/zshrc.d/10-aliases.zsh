# COMMON
# -----------------------------------------------------------------------------

alias ll="ls -lh --color"
alias la="ls -lha --color"
alias tg="tree -aI .git --gitignore"
alias cp="cp -i"
alias mv="mv -i"
alias rms="rm -i"
alias wcp="wl-copy"
alias wpp="wl-paste"

# GIT COMMANDS
# -----------------------------------------------------------------------------

alias ga='git add'
alias gall='git add --all'
alias gc='git commit'
alias gca='git commit --amend'
alias gd='git diff'
alias gl='git log --pretty=oneline'
alias gp='git push'
alias gpf='git push --force'
alias gst='git status'

# SEARCH
# -----------------------------------------------------------------------------
# NOTE: requires `fzf`, `bat`, and `fd`

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

# Search for markdown files with live preview (requires python-rich)
fzmd() {
  local file
  file=$(fd -e md | fzf --preview 'python -m rich.markdown -- {}') || return 1
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

# EDITOR
# -----------------------------------------------------------------------------

alias v="nvim"

nv() {
  local session_file="Session.vim"

  # 1. If you provide any arguments, just run Neovim as usual (ignores session).
  if [ $# -gt 0 ]; then
      nvim "$@"
      return $?
  fi

  # 2. If Session.vim exists, open Neovim with session and close [No Name] buffer after startup.
  if [ -f "$session_file" ]; then
      nvim -S "$session_file" +'silent! bwipeout 1'
      return $?
  fi

  # 3. Fallback: open Neovim normally.
  nvim
}

# KITTY
# -----------------------------------------------------------------------------

alias kimg="kitty +kitten icat"

# EXTRAS
# -----------------------------------------------------------------------------

# Search personal Kanji catalogue
function kanji() {
  local line
  line=$(cat -n "$KANJI_DIC_FILE" | rg "### $1" | cut -f1 | xargs)
  [ -n "$line" ] && nv +$line "$KANJI_DIC_FILE"
}

# Check local weather
wttr() { curl -sS "wttr.in/${WTTR_LOC:-}" 2>/dev/null | sed -n '2,7p' }

# TODO: for some reason looses colors when used in pipes
alias rich="python -m rich.markdown"

# Alternate side-by-side diff viewer
alias delta="DELTA_FEATURES=+side-by-side delta"

alias mpvnv="mpv --no-video --loop"
