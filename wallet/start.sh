#!/bin/bash

config="../config.json"
DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"

KEOSDBINDIR="../bin/bin/keosd"

/bin/echo "Starting Keosd \n";

if [ ! -d "$DIR" ]; then
	/bin/mkdir "$DIR"
fi

$KEOSDBINDIR/keosd --data-dir $DIR --config-dir $DIR > $DIR/stdout.txt 2> $DIR/stderr.txt &  /bin/echo $! > $DIR/keosd.pid
