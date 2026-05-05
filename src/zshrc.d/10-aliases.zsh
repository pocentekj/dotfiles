# COMMON
# -----------------------------------------------------------------------------

alias ll="ls -lh --color"
alias la="ls -lha --color"
alias tg="tree -aI .git --gitignore --filesfirst"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
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

# SHORTCUTS
# -----------------------------------------------------------------------------

alias t='tmux'

# SANE DEFAULTS
# -----------------------------------------------------------------------------

alias fdpp='fd --glob --no-ignore-vcs --hidden --ignore-case'
alias grepp='rg --no-ignore-vcs'
alias diffpp="DELTA_FEATURES=+side-by-side delta"

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

# Check local weather
wttr() { curl -sS "wttr.in/${WTTR_LOC:-}" 2>/dev/null | sed -n '2,7p' }

# Useful for audio in background
alias mpvnv="mpv --no-video --loop"

# Play all .mkv files in current directory
alias mpvall='mpv --playlist=<(find . -name "*.mkv" -print0 | xargs -0 realpath | sort)'
