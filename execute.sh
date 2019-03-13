#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
. $SCRIPT_DIR/config.sh
# ===

if [ "$1" = 'real-run' ]; then
    REALRUN=true
else
    REALRUN=false
fi

if [ "$REALRUN" != true ] || [ "$REALRUN_ENABLED" != true ]; then
    ROTATE_BACKUPS_OPTIONS="--dry-run $ROTATE_BACKUPS_OPTIONS"
fi

CONTAINER_NAME=backup_rotate_rclone
USER=backup

if [ "$REALRUN" = true ] && [ "$REALRUN_ENABLED" = true ]; then
    # REAL RUN !
	echo 'Folgende Dateien werden JETZT gelöscht:'
elif [ "$REALRUN" = true ]; then
    # REAL RUN wurde getriggert, ist aber nicht ENABLED
	echo 'Löschung *DEAKTIVIERT*. Zum Aktivieren `'$ENABLE_CMD'` eingeben.'
	echo 'Folgende Dateien wären jetzt gelöscht worden:'
elif [ "$REALRUN_ENABLED" = true ]; then
    # DRY RUN wurde getriggert, und real run ist ENABLED
	echo 'Folgende Dateien werden beim nächsten Durchlauf am nächsten '$REALRUN_TIME' vom Google Drive gelöscht:'
else
    # DRY RUN wurde getriggert, und real run ist NICHT enabled
	echo 'Tatsächliche Löschung *DEAKTIVIERT*. Zum Aktivieren `'$ENABLE_CMD'` eingeben.'
	echo 'Folgende Dateien wären beim nächsten Durchlauf am nächsten '$REALRUN_TIME' vom Google Drive gelöscht worden:'
fi
FILES=$(docker run -t --rm --name $CONTAINER_NAME \
    -e PUID=$(id -u $USER) \
    -e PGID=$(id -g $USER) \
    -v $RCLONE_CONF:/home/.rclone.conf \
    --device /dev/fuse \
    --privileged \
    cismet/rclone-rotate-backups \
        "$RCLONE_SRC" "$ROTATE_BACKUPS_PATH" "$ROTATE_BACKUPS_OPTIONS" | grep Deleting | awk '{print $7}')
echo '```'
for FILE in $FILES; do
	echo " * backups/${FILE##~/mnt/}"
done
echo '```'
if [ "$REALRUN_ENABLED" = true ]; then
	echo 'Zum Abschalten des automatischen Löschens am nächsten '$REALRUN_TIME' `'$DISABLE_CMD'` eingeben'
else
    echo 'Zum Manuellen entfernen von Dateien `'$MANUAL_CMD'` eingeben.'
fi
