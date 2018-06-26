#!/bin/bash

GLOBALPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
config="$GLOBALPATH/../config.json"
DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"

KEOSDBINDIR="$GLOBALPATH/../bin/bin/keosd"

/bin/echo "Starting Keosd";

if [ ! -d "$DIR" ]; then
	/bin/mkdir "$DIR"
fi

$KEOSDBINDIR --data-dir $DIR --config-dir $DIR > $DIR/stdout.txt 2> $DIR/stderr.txt &  /bin/echo $! > $DIR/keosd.pid
