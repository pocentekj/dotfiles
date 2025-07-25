#!/usr/bin/env python3
import json
import re
import subprocess
from dataclasses import dataclass

# Active workspace color (Catppuccin pink as example)
COLOR_FG_ACTIVE = "#f5c2e7"

# Common arguments for subprocess output check function
SUBPROCESS_OPTS = {
    "text": True,
    "encoding": "utf-8",
    "errors": "replace",
}


@dataclass
class WorkspaceEntry:
    index: int
    active: bool

    def __str__(self) -> str:
        if self.active:
            return f"<span foreground='{COLOR_FG_ACTIVE}'><b>{self.index}</b></span>"
        return str(self.index)


def get_active_workspace() -> int:
    out = subprocess.check_output(["hyprctl", "activeworkspace"], **SUBPROCESS_OPTS)
    match = re.search(r"workspace ID (\d+)", out)
    if match is None:
        raise Exception("Can't find active workspace")
    return int(match.group(1))


def get_all_workspaces(sort: bool = False) -> list[int]:
    out = subprocess.check_output(["hyprctl", "workspaces"], **SUBPROCESS_OPTS)
    workspaces = [int(x) for x in re.findall(r"workspace ID (\d+)", out.strip())]
    if sort:
        return sorted(workspaces)
    return workspaces


def main():
    active_workspace = get_active_workspace()
    entries = [
        WorkspaceEntry(ws, ws == active_workspace)
        for ws in get_all_workspaces(sort=True)
    ]
    print(json.dumps({"text": "  |  ".join(map(str, entries))}))


main()
