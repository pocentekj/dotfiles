# --- workspace auto-tmux (zsh) ----------------------------------------------
# Opt-out per shell or dir:
#   export TMUX_WS_DISABLE=1     # disable globally for this shell
#   touch .tmuxp.noauto          # disable inside a project
#
# Requires: tmux, tmuxp

# Toggle helpers
ws-off() { export TMUX_WS_DISABLE=1; echo "tmux workspaces: OFF"; }
ws-on()  { unset TMUX_WS_DISABLE;   echo "tmux workspaces: ON";  }

# Optional overrides: map absolute paths -> session names
typeset -A TMUX_WS_MAP
# TMUX_WS_MAP[/home/chester/Workspace/projects/pom]=pom
# TMUX_WS_MAP[/home/chester/code/foo]=foo

# Find nearest .tmuxp.yaml upward from $PWD
_ws_find_tmuxp() {
  local d="$PWD"
  while [[ "$d" != "/" ]]; do
    if [[ -f "$d/.tmuxp.noauto" ]]; then return 1; fi
    if [[ -f "$d/.tmuxp.yaml" ]]; then echo "$d/.tmuxp.yaml"; return 0; fi
    d="${d:h}"
  done
  return 1
}

# Derive session name: override map > YAML session_name > dir basename
_ws_session_name_from_yaml() {
  local yaml="$1" root="${1:h}"
  # override?
  if [[ -n ${TMUX_WS_MAP[$root]} ]]; then
    echo "${TMUX_WS_MAP[$root]}"; return 0
  fi
  # read session_name (naive but effective)
  local name
  name=$(awk -F: '/^[[:space:]]*session_name[[:space:]]*:/ {gsub(/[[:space:]]/,"",$1); sub(/^[^:]*:[[:space:]]*/,""); gsub(/'\''|"/,""); print; exit}' "$yaml")
  [[ -n "$name" ]] && { echo "$name"; return 0; }
  # fallback: directory name
  echo "${root:t}"
}

# The hook: fire when directory changes
chpwd() {
  # guards
  [[ -o interactive ]] || return
  [[ -z "$TMUX" ]]      || return
  [[ -z "$TMUX_WS_DISABLE" ]] || return
  command -v tmuxp >/dev/null || return
  command -v tmux  >/dev/null || return

  local yaml; yaml=$(_ws_find_tmuxp) || return
  local sess; sess=$(_ws_session_name_from_yaml "$yaml")

  # If session exists, attach; else create detached via tmuxp, then attach
  if tmux has-session -t "$sess" 2>/dev/null; then
    exec tmux attach -t "$sess"
  else
    # -d / --detached avoids client stealing while panes are built
    tmuxp load -y -d "$yaml" >/dev/null 2>&1 || return
    exec tmux attach -t "$sess"
  fi
}

# Manual helpers
ws-attach() {
  local yaml="$(_ws_find_tmuxp)" || { echo "No .tmuxp.yaml found."; return 1; }
  local sess="$(_ws_session_name_from_yaml "$yaml")"
  tmux has-session -t "$sess" 2>/dev/null || tmuxp load -y -d "$yaml"
  exec tmux attach -t "$sess"
}

ws-save() {
  # Save current/target session layout to nearest .tmuxp.yaml
  local yaml="$(_ws_find_tmuxp)" || { echo "No .tmuxp.yaml found."; return 1; }
  local sess
  if [[ -n "$TMUX" ]]; then
    sess=$(tmux display-message -p '#S')
  else
    sess="$(_ws_session_name_from_yaml "$yaml")"
  fi
  tmuxp freeze "$sess" -f yaml -o "$yaml" && echo "Saved $sess -> $yaml"
}
