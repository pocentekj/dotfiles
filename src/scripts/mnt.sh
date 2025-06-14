#!/bin/bash

# Usage: ./mnt-disk.sh [media|backup|private]
# Toggles mount/unmount of target volume using UUIDs for reliability.

USERNAME=$(whoami)
MOUNT_ROOT="/media/$USERNAME"

# Configure your partitions here (set UUID or LABEL for each!)
declare -A UUIDS=(
    [media]="DEDC624ADC621D51"
    [backup]="538fd42e-750b-41d8-a47e-f7a455674607"
    [private]="395176d8-cd33-45f0-a672-4a855dd18d9f"
)
declare -A TYPES=(
    [media]="ntfs"
    [backup]="luks"
    [private]="luks"
)
declare -A NAMES=(
    [media]="MEDIA"
    [backup]="BACKUP"
    [private]="PRIVATE"
)

usage() {
    echo "Usage: $0 [media|backup|private]"
    exit 1
}

target="$1"
[[ -z "$target" || -z "${UUIDS[$target]}" ]] && usage

MNT_NAME="${NAMES[$target]}"
MNT_DIRN="$MOUNT_ROOT/$MNT_NAME"
TYPE="${TYPES[$target]}"
UUID="${UUIDS[$target]}"

# Resolve DEV_PATH from UUID or LABEL
get_dev_path() {
    if [[ "$UUID" =~ ^[0-9a-fA-F-]+$ ]]; then
        # UUID
        echo "/dev/disk/by-uuid/$UUID"
    else
        # LABEL
        echo "/dev/disk/by-label/$UUID"
    fi
}

DEV_PATH="$(get_dev_path)"

mount_media() {
    sudo mkdir -p "$MNT_DIRN"
    sudo mount "$DEV_PATH" "$MNT_DIRN"
    echo "$MNT_NAME mounted at $MNT_DIRN"
}

mount_luks() {
    sudo mkdir -p "$MNT_DIRN"
    sudo cryptsetup luksOpen "$DEV_PATH" "$MNT_NAME"
    sudo mount "/dev/mapper/$MNT_NAME" "$MNT_DIRN"
    echo "$MNT_NAME mounted at $MNT_DIRN"
}

umount_media() {
    sudo umount "$MNT_DIRN"
    sudo rmdir "$MNT_DIRN" 2>/dev/null
    echo "$MNT_NAME unmounted"
}

umount_luks() {
    sudo umount "$MNT_DIRN"
    sudo rmdir "$MNT_DIRN" 2>/dev/null
    sudo cryptsetup luksClose "$MNT_NAME"
    echo "$MNT_NAME unmounted and closed"
}

is_mounted() {
    mountpoint -q "$MNT_DIRN"
}

if is_mounted; then
    [[ "$TYPE" == "luks" ]] && umount_luks || umount_media
else
    [[ "$TYPE" == "luks" ]] && mount_luks || mount_media
fi
