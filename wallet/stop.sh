#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# keosd EOS wallet stop script
#
# https://github.com/CryptoLions/
#
################################################################################
config="../config.json"
DIR="$( /usr/bin/jq -r '.wallet_data_dir' "$config" )"

    if [ -f $DIR"/wallet.pid" ]; then
        pid=$(/bin/cat $DIR"/wallet.pid")
        /bin/echo $pid
        /bin/kill $pid
        /bin/rm -r $DIR"/wallet.pid"

        /bin/echo -ne "Stoping Wallet"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            /bin/echo -ne "."
            /bin/sleep 1
        done
        /bin/echo -ne "\rWallet stopped. \n"

    fi

