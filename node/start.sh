#!/bin/bash
#######################################################
##                                                   ##
## Script Created by CryptoLions, HKEOS and EOS Rio  ##
## For EOS Ghostbusters Testnet                      ##
##                                                   ##
## https://github.com/CryptoLions                    ##
## https://github.com/eosrio                         ##
## https://github.com/HKEOS/Ghostbusters-Testnet     ##
##                                                   ##
#######################################################

GLOBALPATH=$(/usr/bin/dirname $(/usr/bin/realpath $0))
config="$GLOBALPATH/../config.json"
DATADIR="$( /usr/bin/jq -r '.node_data_dir' "$config" )"

NODEOS="$GLOBALPATH/../bin/bin/nodeos"

/bin/echo "Starting Nodeos";

if [ ! -d "$DATADIR" ]; then
	/bin/mkdir "$DATADIR"
fi

$GLOBALPATH/stop.sh
$NODEOS --data-dir $DATADIR --config-dir $DATADIR "$@" > $DATADIR/stdout.txt 2> $DATADIR/stderr.txt & /bin/echo $! > $DATADIR/nodeos.pid
