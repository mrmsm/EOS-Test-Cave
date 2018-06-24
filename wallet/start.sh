#!/bin/bash

KEOSDBINDIR="/home/ubuntu/EOS-Test-Cave/bin/bin/keosd"
DATADIR="/home/ubuntu/eosio-wallet"

echo "Starting Keosd \n";

$KEOSDBINDIR/keosd --data-dir $DATADIR --config-dir $DATADIR > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt &  echo $! > $DATADIR/keosd.pid
