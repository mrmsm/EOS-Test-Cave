#!/bin/bash

GLOBALPATH=$(/usr/bin/dirname $(/usr/bin/realpath $0))
config="$GLOBALPATH/../config.json"
DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"

KEOSDBINDIR="/opt/eosio/bin/keosd"

/bin/echo "Starting Keosd";

if [ ! -d "$DIR" ]; then
	/bin/mkdir "$DIR"
fi

$KEOSDBINDIR --data-dir $DIR --config-dir $DIR > $DIR/stdout.txt 2> $DIR/stderr.txt &  /bin/echo $! > $DIR/keosd.pid
