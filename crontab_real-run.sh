#!/bin/sh

TIMESTAMP=$(date +"%s")
STDOUT_LOG=/var/log/rotate-backups_${TIMESTAMP}.log
STDERR_LOG=/var/log/rotate-backups_${TIMESTAMP}_error.log

###

BR_MAIL_TO=admin
BR_MAIL_SUBJECT="rotate-backups real-run"

/usr/local/src/rotate-backups/execute.sh real-run \
    1>> "$STDOUT_LOG" \
    2>> "$STDERR_LOG"

cat "$STDOUT_LOG" "$STDERR_LOG" # | mailx -Sttycharset=utf8 -s "$BR_MAIL_SUBJECT" "$BR_MAIL_TO"
