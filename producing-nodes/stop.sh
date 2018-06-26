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

GLOBALPATH=$(pwd)
config="$GLOBALPATH/../config.json"
DIR="$( /usr/bin/jq -r '.node_data_dir_2' "$config" )"

    if [ -f $DIR"/nodeos.pid" ]; then
        pid=$(/bin/cat $DIR"/nodeos.pid")
        /bin/echo $pid
        /bin/kill $pid
        /bin/rm -r $DIR"/nodeos.pid"

        /bin/echo -ne "Stopping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            /bin/echo -ne "."
            /bin/sleep 1
        done
        /bin/echo -ne "\rNodeos stopped. \n"

    fi
