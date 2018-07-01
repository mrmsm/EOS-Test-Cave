#!/bin/bash

GLOBALPATH=$(/usr/bin/dirname $(/usr/bin/realpath $0))
config="$GLOBALPATH/../config.json"
DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"
KEOSDBINDIR="$( /usr/bin/jq -r '.keosd_bin' "$config" )"
WALLET_ADDRESS="$( /usr/bin/jq -r '.walletAddr' "$config" )"

/bin/echo "Starting Keosd";

if [ ! -d "$DIR" ]; then
	/bin/mkdir "$DIR"
fi

$KEOSDBINDIR --data-dir $DIR --config-dir $DIR --http-server-address $WALLET_ADDRESS > $DIR/stdout.txt 2> $DIR/stderr.txt &  /bin/echo $! > $DIR/keosd.pid
