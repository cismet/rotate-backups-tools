#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
. $SCRIPT_DIR/config.sh
# ===

if [ "$REALRUN_ENABLED" = false ]; then
	touch $REALRUN_ENABLED_FILE
	echo 'Automatisches Löschen wurde aktiviert. Nächster Durchlauf am '$REALRUN_TIME'.'
fi
