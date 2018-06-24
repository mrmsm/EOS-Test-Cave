#!/bin/bash

config="../config.json"
DIR="$( jq -r '.wallet_data_dir' "$config" )"

KEOSDBINDIR="../bin/bin/keosd"

echo "Starting Keosd \n";

$KEOSDBINDIR/keosd --data-dir $DIR --config-dir $DIR > $DIR/stdout.txt 2> $DIR/stderr.txt &  echo $! > $DIR/keosd.pid
