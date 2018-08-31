#!/usr/bin/env bash

SCRIPTDIR=$(dirname "$0")

if [[ $1 == D ]]; then
    BACKUP_PERIOD="daily"
    REMOVE_TIMESPAN_DAYS=+6
elif [[ $1 == W ]]; then
    BACKUP_PERIOD="weekly"
    REMOVE_TIMESPAN_DAYS=+21
elif [[ $1 == M ]]; then
    BACKUP_PERIOD="monthly"
    REMOVE_TIMESPAN_DAYS=+93
elif [[ $1 == H ]]; then
    BACKUP_PERIOD="hourly"
    REMOVE_TIMESPAN_DAYS=+1
else
    echo "Time period parameter not supplied should be H, D, W or M"
    exit 1
fi

SOURCE_FOLDER="$2"
DESTINATION_FOLDER="$3"

if [ -z "$SOURCE_FOLDER" ]; then
        echo "Source folder has not been provided"
        exit 1
fi

if [ -z "$DESTINATION_FOLDER" ]; then
        echo "Destination folder has not been provided"
        exit 1
fi

TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="$DESTINATION_FOLDER/$BACKUP_PERIOD"
LATEST_DIR="$DESTINATION_FOLDER/latest"

mkdir -p "$BACKUP_DIR"
mkdir -p "$LATEST_DIR"
rm $LATEST_DIR/${HOSTNAME}*

zip -r $BACKUP_DIR/${HOSTNAME}_${TIMESTAMP}.zip $SOURCE_FOLDER
cp $BACKUP_DIR/${HOSTNAME}_${TIMESTAMP}.zip $LATEST_DIR

find $BACKUP_DIR -ctime $REMOVE_TIMESPAN_DAYS -exec rm {} + >/dev/null 2>&1


