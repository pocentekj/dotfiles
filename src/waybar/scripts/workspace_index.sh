#!/bin/bash
id=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')
echo "{\"text\": \"$id\", \"class\": \"ws-$id\", \"tooltip\": \"Current workspace: $id\"}"

