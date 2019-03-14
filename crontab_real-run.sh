#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
. $SCRIPT_DIR/config.sh
# ===

TIMESTAMP=$(date +"%s")
STDOUT_LOG=/var/log/rotate-backups_${TIMESTAMP}.log
STDERR_LOG=/var/log/rotate-backups_${TIMESTAMP}_error.log

BR_MAIL_TO=admin
BR_MAIL_SUBJECT="rotate-backups real-run"

$SCRIPT_DIR/execute.sh real-run \
    1>> "$STDOUT_LOG" \
    2>> "$STDERR_LOG"

# ===

export SLACK_UPLOAD_URL=$SLACK_UPLOAD_URL
export SLACK_TOKEN=$SLACK_TOKEN
export SLACK_HOOK=$SLACK_HOOK
export SLACK_USERNAME=$SLACK_USERNAME
export SLACK_CHANNEL=$SLACK_CHANNEL

$SLACK_SH -i ':warning:' -f "$STDERR_LOG" -m "$(cat $STDOUT_LOG)"