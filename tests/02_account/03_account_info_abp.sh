#!/bin/bash

TEST_NAME="Get account info"

if [[ ! $GLOBALPATH ]]; then
    GLOBALPATH="$(dirname $(realpath $0))/../.."
fi

config="$GLOBALPATH/config.json"
NAME="$( jq -r '.abp_account_name' "$config" )"

failed(){
    echo "0:$TEST_NAME"
    echo "$TEST_NAME - Failed" >> $GLOBALPATH/log/log_error.log;
    echo "$1" >> $GLOBALPATH/log/log_error.log;
    echo "---------------------------------" >> $GLOBALPATH/log/log_error.log;
}

tpm_stderr="$GLOBALPATH/log/tmp_std_err.log"

#----------------------

CMD=$( $GLOBALPATH/bin/cleos.sh get account $NAME 2>$tpm_stderr)

ERR=$(cat $tpm_stderr)

if [[ $ERR != "" ]]; then
    failed "$ERR"
    rm $tpm_stderr;
else
    echo "1:$TEST_NAME"
fi
