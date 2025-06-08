#!/bin/bash

# Mount NTFS partition from external USB drive.
USERNAME=$(whoami)
MNT_NAME="MEDIA"
MNT_DIRN="/media/$USERNAME/$MNT_NAME"
DEV_PATH="/dev/sda1"

function mount_media() {
    sudo mkdir -p "$MNT_DIRN"
    sudo mount "$DEV_PATH" "$MNT_DIRN"
    echo "$MNT_NAME: $MNT_DIRN"
}

function umount_media() {
    sudo umount "$MNT_DIRN"
    sudo rmdir "$MNT_DIRN" 2>/dev/null
    echo "$MNT_NAME removed"
}

if mount -l | grep -q "$MNT_DIRN"; then
    umount_media
else
    mount_media
fi

