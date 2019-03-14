#!/bin/sh
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

HOSTNAME=$(hostname)
RCLONE_CONF=/etc/milquetoast/rclone.conf
RCLONE_SRC=gdrive:/cismet/backups/
ROTATE_BACKUPS_PATH='*'
ROTATE_BACKUPS_OPTIONS='--daily=10 --weekly=5 --monthly=13 --yearly=5'
REALRUN_ENABLED_FILE=$SCRIPT_DIR/realrun.enabled
REALRUN_TIME='Freitag (22:00)'
DISABLE_CMD="ssh $HOSTNAME $SCRIPT_DIR/disable.sh"
ENABLE_CMD="ssh $HOSTNAME $SCRIPT_DIR/enable.sh"
MANUAL_CMD="ssh $HOSTNAME $SCRIPT_DIR/manual.sh"
SLACK_SH=/usr/local/src/slack.sh
SLACK_TOKEN=***
SLACK_HOOK=***
SLACK_CHANNEL=#admin
SLACK_USERNAME=$HOSTNAME
SLACK_UPLOAD_URL=https://slack.com/api/files.upload

if [ -f "$REALRUN_ENABLED_FILE" ]; then
    REALRUN_ENABLED=true
else
    REALRUN_ENABLED=false
fi
