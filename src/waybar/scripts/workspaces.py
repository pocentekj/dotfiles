#!/usr/bin/env python3
import subprocess
import re
import json

# Colors (Catppuccin pink as example)
active_fg = "#f5c2e7"

# Common arguments for subprocess output check function
ws_out_opts = {
    "text": True,
    "encoding": "utf-8",
    "errors": "replace",
}

# Get active workspace
active = int(re.search(r"workspace ID (\d+)", subprocess.check_output(["hyprctl", "activeworkspace"], **ws_out_opts)).group(1))

# Get all workspaces
ws_raw = subprocess.check_output(["hyprctl", "workspaces"], **ws_out_opts)
blocks = re.split(r"\n(?=workspace ID)", ws_raw.strip())

parts = []
tooltip = None
for b in blocks:
    match = re.search(r"workspace ID (\d+)", b)
    if not match:
        continue
    wsid = int(match.group(1))
    title = re.search(r"lastwindowtitle: (.*)", b)
    title_str = title.group(1) if title else ""
    if wsid == active:
        parts.append(f"<span foreground='{active_fg}'><b>{wsid}</b></span>")
        tooltip = title_str or f"Workspace {wsid}"
    else:
        parts.append(f"{wsid}")

# Output a single JSON object as required by Waybar
print(json.dumps({
    "text": " | ".join(parts),
    "tooltip": tooltip or "No title"
}))

