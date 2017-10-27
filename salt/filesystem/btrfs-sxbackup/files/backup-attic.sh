#!/bin/bash
mount /mnt/backup || exit 1
echo "Starting the backup"

if [ ! -f /mnt/backup/.btrfs-sxbackup ] ; then
    btrfs-sxbackup init -sr 10 -dr 30 /srv/attic /mnt/backup
fi
btrfs-sxbackup run /mnt/backup

umount /mnt/backup
