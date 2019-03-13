#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
. $SCRIPT_DIR/config.sh
# ===

if [ "$REALRUN_ENABLED" = true ]; then
	rm $REALRUN_ENABLED_FILE
	echo 'Automatisches Löschen wurde deaktiviert.'
fi
