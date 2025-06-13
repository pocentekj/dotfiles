#!/bin/bash

# Mount encrypted Private partition from external USB drive.
USERNAME=$(whoami)
MNT_NAME="BACKUP"
MNT_DIRN="/media/$USERNAME/$MNT_NAME"
DEV_PATH="/dev/sda2"

function mount_priv() {
    sudo mkdir -p "$MNT_DIRN"
    sudo cryptsetup luksOpen "$DEV_PATH" "$MNT_NAME"
    sudo mount "/dev/mapper/$MNT_NAME" "$MNT_DIRN"
    echo "$MNT_NAME: $MNT_DIRN"
}

function umount_priv() {
    sudo umount "$MNT_DIRN"
    sudo rmdir "$MNT_DIRN" 2>/dev/null
    sudo cryptsetup luksClose "$MNT_NAME"
    echo "$MNT_NAME removed"
}

if mount -l | grep -q "$MNT_DIRN"; then
    umount_priv
else
    mount_priv
fi
