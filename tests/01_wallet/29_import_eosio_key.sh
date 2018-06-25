#!/bin/bash

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

[ -z $BASE_DIR ] && . "$GLOBALPATH/config.conf"
KEY="$eosio_key"

TEST_NAME="Import eosio key to wallet"

failed(){
    echo "1:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#-------------------------------------------------------

CMD=$($GLOBALPATH/bin/cleos.sh wallet import $KEY 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != "" ]]; then
    failed "$ERR"
    rm $tpm_stderr
else
        echo "0:$TEST_NAME"
fi
