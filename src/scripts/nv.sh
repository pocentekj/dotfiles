#!/usr/bin/env bash

# Usage: nv [file1 [file2 ...]]

SESSION_FILE="Session.vim"

# 1. If you provide any arguments, just run Neovim as usual (ignores session).
if [ $# -gt 0 ]; then
    nvim "$@"
    exit $?
fi

# 2. If Session.vim exists, open Neovim with session and close [No Name] buffer after startup.
if [ -f "$SESSION_FILE" ]; then
    nvim -S "$SESSION_FILE" +'silent! bwipeout 1'
    exit $?
fi

# 3. Fallback: open Neovim normally.
nvim

