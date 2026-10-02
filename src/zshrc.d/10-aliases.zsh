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
alias gck='git checkout'
alias gl='git log --pretty=oneline'
alias gp='git push'
alias gpf='git push --force'
alias gst='git status'

gd() {
  git diff "$@" | delta
}

# SHORTCUTS
# -----------------------------------------------------------------------------

alias t='tmux'
alias batcut='bat --wrap=never'

# SUDO-ALIASES
# -----------------------------------------------------------------------------
# Meant to be used with `NOPASSWD` in `sudoers` file

alias reboot='sudo /usr/bin/reboot'
alias poweroff='sudo /usr/bin/poweroff'

# SANE DEFAULTS
# -----------------------------------------------------------------------------

alias fdpp='fd --glob --no-ignore-vcs --hidden --ignore-case'

# EDITOR
# -----------------------------------------------------------------------------

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
