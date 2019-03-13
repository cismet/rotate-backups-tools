#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
. $SCRIPT_DIR/config.sh
# ===

DATA=$(pwd)/data
CONTAINER_NAME=backup_rotate_rclone
USER=backup

FILES=$(docker run -t --rm --name $CONTAINER_NAME \
    -e PUID=$(id -u $USER) \
    -e PGID=$(id -g $USER) \
    -v $RCLONE_CONF:/home/.rclone.conf \
    --device /dev/fuse \
    --privileged \
    cismet/rclone-rotate-backups \
        "$RCLONE_SRC" "$ROTATE_BACKUPS_PATH" "$ROTATE_BACKUPS_OPTIONS" | grep Deleting | awk '{print $7}')

RCLONE_MOUNT=backups
echo "# mount_rlcone.sh => https://gist.github.com/jeanatcismet/096ecafc0cdabf163e8e0257a31ea7eb#file-mount_rclone-sh"
echo "mkdir -p $RCLONE_MOUNT && ./mount_rclone.sh \$(pwd)/rclone.conf $RCLONE_SRC \$(pwd)/$RCLONE_MOUNT"
echo "# paste in another console => "
for FILE in $FILES; do
	echo rm ./$RCLONE_MOUNT/${FILE##"~/mnt/"}
done
